import argv
import birdie
import gleam/dict
import gleam/int
import gleam/io
import gleam/string
import simplifile

pub type Part =
  fn(String) -> Int

pub type Day =
  #(Part, Part, String)

pub type Days =
  List(#(Int, Day))

@external(erlang, "timer", "tc")
fn time(fun: fn() -> a) -> #(Int, a)

pub fn run(year: Int, days: Days) -> Nil {
  case argv.load().arguments {
    [day] -> run_day(year, day, days, snapshot: False)
    [day, "--check"] -> run_day(year, day, days, snapshot: True)
    _else -> panic as "arguments"
  }
}

fn run_day(year: Int, day: String, days: Days, snapshot snap: Bool) -> Nil {
  let assert Ok(day) = int.parse(day) as "parse day"
  let days = dict.from_list(days)
  let assert Ok(#(part1, part2, input)) = dict.get(days, day) as "get day"
  let assert Ok(input) = simplifile.read(input) as "read input"

  let #(part1, time1) = run_part(part1, input)
  let #(part2, time2) = run_part(part2, input)
  let time1 = "(" <> time1 <> ")"
  let time2 = "(" <> time2 <> ")"

  let day = string.pad_start(int.to_string(day), 2, "0")
  let year = int.to_string(year)
  let timestamp = year <> "-" <> day

  case snap {
    True -> birdie.snap(part1 <> ", " <> part2, timestamp)
    False -> Nil
  }

  [timestamp, part1, time1, part2, time2]
  |> string.join(" ")
  |> io.println
}

pub fn run_part(part: Part, input: String) -> #(String, String) {
  let #(time, result) = time(fn() { part(input) })
  let time = int.to_string(time / 1000) <> "ms"
  #(int.to_string(result), time)
}
