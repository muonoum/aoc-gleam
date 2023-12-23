import aoc/day01
import aoc/day02
import aoc/day03
import aoc/day04
import aoc/day05
import aoc/day06
import aoc/day07
import aoc/day08
import aoc/day09
import aoc/day10
import aoc/day11
import aoc/day13
import aoc/day14
import aoc/day15
import aoc/day16
import aoc/day18
import aoc/day19
import aoc/day21
import gleam/dict
import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/task
import gleam/string
import simplifile

@external(erlang, "timer", "tc")
fn time(fun: fn() -> a) -> #(Int, a)

pub fn days() {
  dict.from_list([
    #(01, #(day01.part1, day01.part2, "inputs/day01.txt")),
    #(02, #(day02.part1, day02.part2, "inputs/day02.txt")),
    #(03, #(day03.part1, day03.part2, "inputs/day03.txt")),
    #(04, #(day04.part1, day04.part2, "inputs/day04.txt")),
    #(05, #(day05.part1, day05.part2, "inputs/day05.txt")),
    #(06, #(day06.part1, day06.part2, "inputs/day06.txt")),
    #(07, #(day07.part1, day07.part2, "inputs/day07.txt")),
    #(08, #(day08.part1, day08.part2, "inputs/day08.txt")),
    #(09, #(day09.part1, day09.part2, "inputs/day09.txt")),
    #(10, #(day10.part1, day10.part2, "inputs/day10.txt")),
    #(11, #(day11.part1, day11.part2, "inputs/day11.txt")),
    #(13, #(day13.part1, day13.part2, "inputs/day13.txt")),
    #(14, #(day14.part1, day14.part2, "inputs/day14.txt")),
    #(15, #(day15.part1, day15.part2, "inputs/day15.txt")),
    #(16, #(day16.part1, day16.part2, "inputs/day16.txt")),
    #(18, #(day18.part1, day18.part2, "inputs/day18.txt")),
    #(19, #(day19.part1, day19.part2, "inputs/day19.txt")),
    #(21, #(day21.part1, day21.part2, "inputs/day21.txt")),
  ])
}

pub fn main() {
  let days = days()

  case erlang.start_arguments() {
    [day] -> {
      let assert Ok(day) = int.parse(day)
      let assert Ok(#(part1, part2, input)) = dict.get(days, day)
      [io.println(run_day(day, part1, part2, input))]
    }

    [] -> {
      dict.values({
        use day, #(part1, part2, input) <- dict.map_values(days)
        use <- task.async
        run_day(day, part1, part2, input)
      })
      |> list.map(task.await_forever)
      |> list.map(io.println)
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
