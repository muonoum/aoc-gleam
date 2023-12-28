import gleam/dict
import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/string
import simplifile
import aoc2015
import aoc2020
import aoc2021
import aoc2022
import aoc2023

@external(erlang, "timer", "tc")
fn time(fun: fn() -> a) -> #(Int, a)

const years = [
  #(15, aoc2015.days),
  #(20, aoc2020.days),
  #(21, aoc2021.days),
  #(22, aoc2022.days),
  #(23, aoc2023.days),
]

pub fn main() {
  case erlang.start_arguments() {
    [year, day] -> {
      let assert Ok(year) = int.parse(year)
      let assert Ok(day) = int.parse(day)
      let assert Ok(days) =
        list.map(years, pair.map_second(_, dict.from_list))
        |> dict.from_list
        |> dict.get(year)
      let assert Ok(#(part1, part2, input)) = dict.get(days, day)
      [io.println(run_day(day, part1, part2, input))]
    }

    _ -> panic
  }
}

pub fn noop(_) {
  -1
}

pub fn run_day(day, part1, part2, input) {
  let assert Ok(input) = simplifile.read(input)
  let day = string.pad_left(int.to_string(day), 2, "0")
  [day, run_part(part1, input), run_part(part2, input)]
  |> string.join(" ")
}

pub fn run_part(part, input) {
  let #(time, result) = time(fn() { part(input) })
  let time = int.to_string(time / 1000) <> "ms"
  [int.to_string(result), "(" <> time <> ")"]
  |> string.join(" ")
}
