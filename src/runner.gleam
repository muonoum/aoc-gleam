import argv
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

pub fn run(days: Days) -> List(Nil) {
  case argv.load().arguments {
    [day] -> {
      let assert Ok(day) = int.parse(day) as "parse day"
      let days = dict.from_list(days)
      let assert Ok(#(part1, part2, input)) = dict.get(days, day) as "get day"
      [io.println(run_day(day, part1, part2, input))]
    }

    _else -> panic as "arguments"
  }
}

pub fn run_day(day: Int, part1: Part, part2: Part, input: String) -> String {
  let assert Ok(input) = simplifile.read(input) as "read input"
  let day = string.pad_start(int.to_string(day), 2, "0")
  [day, run_part(part1, input), run_part(part2, input)]
  |> string.join(" ")
}

pub fn run_part(part: Part, input: String) -> String {
  let #(time, result) = time(fn() { part(input) })
  let time = int.to_string(time / 1000) <> "ms"
  [int.to_string(result), "(" <> time <> ")"]
  |> string.join(" ")
}
