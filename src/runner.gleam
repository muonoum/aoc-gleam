import argv
import birdie
import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/string
import simplifile

pub type Part =
  fn(String) -> Int

pub type Day =
  #(Part, Part)

pub type Mode {
  Checked
  Unchecked
  Example(String)
}

@external(erlang, "timer", "tc")
fn time(fun: fn() -> a) -> #(Int, a)

pub fn run(year: Int, days: List(#(Int, Day))) -> Nil {
  let days = dict.from_list(days)

  case argv.load().arguments {
    [day] -> run_day(days, year, day, Unchecked)
    [day, "--example", path] -> run_day(days, year, day, Example(path))
    [day, "--check"] -> run_day(days, year, day, Checked)
    _else -> panic as "arguments"
  }
}

fn get_path(year: Int, day: String, mode: Mode) -> String {
  case mode {
    Example(path) -> path

    _else ->
      "inputs" <> "/" <> int.to_string(year) <> "/" <> "day" <> day <> ".txt"
  }
}

fn run_day(days: Dict(Int, Day), year: Int, day: String, mode: Mode) -> Nil {
  let day = string.pad_start(day, 2, "0")
  let path = get_path(year, day, mode)
  use timestamp, part1, part2 <- do(days, year, day, path)
  use <- bool.guard(mode != Checked, Nil)
  birdie.snap(part1 <> ", " <> part2, timestamp)
}

fn do(
  days: Dict(Int, Day),
  year: Int,
  day: String,
  path: String,
  then: fn(String, String, String) -> a,
) -> Nil {
  let timestamp = int.to_string(year) <> "-" <> day
  let assert Ok(day) = int.parse(day) as "parse day"
  let assert Ok(#(part1, part2)) = dict.get(days, day) as "get day"

  let assert Ok(input) = simplifile.read(path) as "read input"
  let #(part1, time1) = run_part(part1, input)
  let #(part2, time2) = run_part(part2, input)

  then(timestamp, part1, part2)

  [timestamp, part1, "(" <> time1 <> ")", part2, "(" <> time2 <> ")"]
  |> string.join(" ")
  |> io.println
}

fn run_part(part: Part, input: String) -> #(String, String) {
  let #(time, result) = time(fn() { part(input) })
  let time = int.to_string(time / 1000) <> "ms"
  #(int.to_string(result), time)
}
