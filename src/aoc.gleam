import gleam/dict
import gleam/erlang
import gleam/int
import gleam/io
import gleam/string
import simplifile
// 2015
import aoc15/day01 as day1501
import aoc15/day02 as day1502
// 2022
import aoc22/day01 as day2201
import aoc22/day02 as day2202
import aoc22/day03 as day2203
import aoc22/day04 as day2204
import aoc22/day05 as day2205
import aoc22/day06 as day2206
import aoc22/day10 as day2210
// 2023
import aoc23/day01 as day2301
import aoc23/day02 as day2302
import aoc23/day03 as day2303
import aoc23/day04 as day2304
import aoc23/day05 as day2305
import aoc23/day06 as day2306
import aoc23/day07 as day2307
import aoc23/day08 as day2308
import aoc23/day09 as day2309
import aoc23/day10 as day2310
import aoc23/day11 as day2311
import aoc23/day13 as day2313
import aoc23/day14 as day2314
import aoc23/day15 as day2315
import aoc23/day16 as day2316
import aoc23/day18 as day2318
import aoc23/day19 as day2319
import aoc23/day21 as day2321
import aoc23/day24 as day2324
import aoc23/day25 as day2325

@external(erlang, "timer", "tc")
fn time(fun: fn() -> a) -> #(Int, a)

pub fn aoc23() {
  dict.from_list([
    #(01, #(day2301.part1, day2301.part2, "inputs/23/day01.txt")),
    #(02, #(day2302.part1, day2302.part2, "inputs/23/day02.txt")),
    #(03, #(day2303.part1, day2303.part2, "inputs/23/day03.txt")),
    #(04, #(day2304.part1, day2304.part2, "inputs/23/day04.txt")),
    #(05, #(day2305.part1, day2305.part2, "inputs/23/day05.txt")),
    #(06, #(day2306.part1, day2306.part2, "inputs/23/day06.txt")),
    #(07, #(day2307.part1, day2307.part2, "inputs/23/day07.txt")),
    #(08, #(day2308.part1, day2308.part2, "inputs/23/day08.txt")),
    #(09, #(day2309.part1, day2309.part2, "inputs/23/day09.txt")),
    #(10, #(day2310.part1, day2310.part2, "inputs/23/day10.txt")),
    #(11, #(day2311.part1, day2311.part2, "inputs/23/day11.txt")),
    #(13, #(day2313.part1, day2313.part2, "inputs/23/day13.txt")),
    #(14, #(day2314.part1, day2314.part2, "inputs/23/day14.txt")),
    #(15, #(day2315.part1, day2315.part2, "inputs/23/day15.txt")),
    #(16, #(day2316.part1, day2316.part2, "inputs/23/day16.txt")),
    #(18, #(day2318.part1, day2318.part2, "inputs/23/day18.txt")),
    #(19, #(day2319.part1, day2319.part2, "inputs/23/day19.txt")),
    #(21, #(day2321.part1, day2321.part2, "inputs/23/day21.txt")),
    #(24, #(day2324.part1, day2324.part2, "inputs/23/day24.txt")),
    #(25, #(day2325.part1, day2325.part2, "inputs/23/day25.txt")),
  ])
}

pub fn aoc22() {
  dict.from_list([
    #(01, #(day2201.part1, day2201.part2, "inputs/22/day01.txt")),
    #(02, #(day2202.part1, day2202.part2, "inputs/22/day02.txt")),
    #(03, #(day2203.part1, day2203.part2, "inputs/22/day03.txt")),
    #(04, #(day2204.part1, day2204.part2, "inputs/22/day04.txt")),
    #(05, #(day2205.part1, day2205.part2, "inputs/22/day05.txt")),
    #(06, #(day2206.part1, day2206.part2, "inputs/22/day06.txt")),
    #(10, #(day2210.part1, day2210.part2, "inputs/22/day10.txt")),
  ])
}

pub fn aoc15() {
  dict.from_list([
    #(01, #(day1501.part1, day1501.part2, "inputs/15/day01.txt")),
    #(02, #(day1502.part1, day1502.part2, "inputs/15/day02.txt")),
  ])
}

pub fn main() {
  let years = dict.from_list([#(15, aoc15()), #(22, aoc22()), #(23, aoc23())])

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
