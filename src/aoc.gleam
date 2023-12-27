import gleam/dict
import gleam/erlang
import gleam/int
import gleam/io
import gleam/string
import simplifile
// 2015
import year15/day01 as year15day01
import year15/day02 as year15day02
// 2021
import year21/day01 as year21day01
// 2022
import year22/day01 as year22day01
import year22/day02 as year22day02
import year22/day03 as year22day03
import year22/day04 as year22day04
import year22/day05 as year22day05
import year22/day06 as year22day06
import year22/day10 as year22day10
// 2023
import year23/day01 as year23day01
import year23/day02 as year23day02
import year23/day03 as year23day03
import year23/day04 as year23day04
import year23/day05 as year23day05
import year23/day06 as year23day06
import year23/day07 as year23day07
import year23/day08 as year23day08
import year23/day09 as year23day09
import year23/day10 as year23day10
import year23/day11 as year23day11
import year23/day13 as year23day13
import year23/day14 as year23day14
import year23/day15 as year23day15
import year23/day16 as year23day16
import year23/day18 as year23day18
import year23/day19 as year23day19
import year23/day21 as year23day21
import year23/day24 as year23day24
import year23/day25 as year23day25

@external(erlang, "timer", "tc")
fn time(fun: fn() -> a) -> #(Int, a)

pub fn year15() {
  dict.from_list([
    #(01, #(year15day01.part1, year15day01.part2, "data/year15/day01.txt")),
    #(02, #(year15day02.part1, year15day02.part2, "data/year15/day02.txt")),
  ])
}

pub fn year21() {
  dict.from_list([
    #(01, #(year21day01.part1, year21day01.part2, "data/year21/day01.txt")),
  ])
}

pub fn year22() {
  dict.from_list([
    #(01, #(year22day01.part1, year22day01.part2, "data/year22/day01.txt")),
    #(02, #(year22day02.part1, year22day02.part2, "data/year22/day02.txt")),
    #(03, #(year22day03.part1, year22day03.part2, "data/year22/day03.txt")),
    #(04, #(year22day04.part1, year22day04.part2, "data/year22/day04.txt")),
    #(05, #(year22day05.part1, year22day05.part2, "data/year22/day05.txt")),
    #(06, #(year22day06.part1, year22day06.part2, "data/year22/day06.txt")),
    #(10, #(year22day10.part1, year22day10.part2, "data/year22/day10.txt")),
  ])
}

pub fn year23() {
  dict.from_list([
    #(01, #(year23day01.part1, year23day01.part2, "data/year23/day01.txt")),
    #(02, #(year23day02.part1, year23day02.part2, "data/year23/day02.txt")),
    #(03, #(year23day03.part1, year23day03.part2, "data/year23/day03.txt")),
    #(04, #(year23day04.part1, year23day04.part2, "data/year23/day04.txt")),
    #(05, #(year23day05.part1, year23day05.part2, "data/year23/day05.txt")),
    #(06, #(year23day06.part1, year23day06.part2, "data/year23/day06.txt")),
    #(07, #(year23day07.part1, year23day07.part2, "data/year23/day07.txt")),
    #(08, #(year23day08.part1, year23day08.part2, "data/year23/day08.txt")),
    #(09, #(year23day09.part1, year23day09.part2, "data/year23/day09.txt")),
    #(10, #(year23day10.part1, year23day10.part2, "data/year23/day10.txt")),
    #(11, #(year23day11.part1, year23day11.part2, "data/year23/day11.txt")),
    #(13, #(year23day13.part1, year23day13.part2, "data/year23/day13.txt")),
    #(14, #(year23day14.part1, year23day14.part2, "data/year23/day14.txt")),
    #(15, #(year23day15.part1, year23day15.part2, "data/year23/day15.txt")),
    #(16, #(year23day16.part1, year23day16.part2, "data/year23/day16.txt")),
    #(18, #(year23day18.part1, year23day18.part2, "data/year23/day18.txt")),
    #(19, #(year23day19.part1, year23day19.part2, "data/year23/day19.txt")),
    #(21, #(year23day21.part1, year23day21.part2, "data/year23/day21.txt")),
    #(24, #(year23day24.part1, year23day24.part2, "data/year23/day24.txt")),
    #(25, #(year23day25.part1, year23day25.part2, "data/year23/day25.txt")),
  ])
}

pub fn main() {
  let years =
    dict.from_list([
      #(15, year15()),
      #(21, year21()),
      #(22, year22()),
      #(23, year23()),
    ])

  case erlang.start_arguments() {
    [year, day] -> {
      let assert Ok(year) = int.parse(year)
      let assert Ok(day) = int.parse(day)
      let assert Ok(days) = dict.get(years, year)
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
