import argv
import birdie
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/string
import simplifile

pub type Part =
  fn(String) -> Int

pub type Day =
  #(Part, Part, String)

@external(erlang, "timer", "tc")
fn time(fun: fn() -> a) -> #(Int, a)

pub fn run(year: Int, days: List(#(Int, Day))) -> Nil {
  let days = dict.from_list(days)

  case argv.load().arguments {
    [day] -> run_day(year, day, days, check: False)
    [day, "--check"] -> run_day(year, day, days, check: True)
    _else -> panic as "arguments"
  }
}

fn get_day(days: Dict(Int, Day), day: String) -> #(Part, Part, String) {
  let assert Ok(day) = int.parse(day) as "parse day"
  let assert Ok(#(part1, part2, input)) = dict.get(days, day) as "get day"
  let assert Ok(input) = simplifile.read(input) as "read input"
  #(part1, part2, input)
}

fn run_day(
  year: Int,
  day: String,
  days: Dict(Int, Day),
  check check: Bool,
) -> Nil {
  let timestamp = int.to_string(year) <> "-" <> string.pad_start(day, 2, "0")
  let #(part1, part2, input) = get_day(days, day)

  let #(part1, time1) = run_part(part1, input)
  let #(part2, time2) = run_part(part2, input)

  case check {
    True -> birdie.snap(part1 <> ", " <> part2, timestamp)
    False -> Nil
  }

  [timestamp, part1, "(" <> time1 <> ")", part2, "(" <> time2 <> ")"]
  |> string.join(" ")
  |> io.println
}

fn run_part(part: Part, input: String) -> #(String, String) {
  let #(time, result) = time(fn() { part(input) })
  let time = int.to_string(time / 1000) <> "ms"
  #(int.to_string(result), time)
}
