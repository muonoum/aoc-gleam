import aoc/day1
import aoc/day2
import aoc/day3
import aoc/day4
import aoc/day5
import aoc/day6
import aoc/day8
import aoc/day9
import gleam/dict
import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/task
import simplifile

pub type Day {
  Day(Int, Int, Int)
}

fn day1() {
  let assert Ok(input) = simplifile.read("inputs/day1.txt")
  Day(1, day1.part1(input), day1.part2(input))
}

fn day2() {
  let assert Ok(input) = simplifile.read("inputs/day2.txt")
  Day(2, day2.part1(input), day2.part2(input))
}

fn day3() {
  let assert Ok(input) = simplifile.read("inputs/day3.txt")
  Day(3, day3.part1(input), day3.part2(input))
}

fn day4() {
  let assert Ok(input) = simplifile.read("inputs/day4.txt")
  Day(4, day4.part1(input), day4.part2(input))
}

fn day5() {
  let assert Ok(input) = simplifile.read("inputs/day5.txt")
  Day(5, day5.part1(input), day5.part2(input))
}

fn day6() {
  let assert Ok(input) = simplifile.read("inputs/day6.txt")
  Day(6, day6.part1(input), day6.part2(input))
}

fn day8() {
  let assert Ok(input) = simplifile.read("inputs/day8.txt")
  Day(8, day8.part1(input), day8.part2(input))
}

fn day9() {
  let assert Ok(input) = simplifile.read("inputs/day9.txt")
  Day(9, day9.part1(input), day9.part2(input))
}

fn day_order(a, b) {
  case a, b {
    Day(a, _, _), Day(b, _, _) -> int.compare(a, b)
  }
}

pub fn main() {
  let days =
    dict.from_list([
      #("1", day1),
      #("2", day2),
      #("3", day3),
      #("4", day4),
      #("5", day5),
      #("6", day6),
      #("8", day8),
      #("9", day9),
    ])

  case erlang.start_arguments() {
    [day] -> {
      let assert Ok(day) = dict.get(days, day)
      [io.debug(day())]
    }

    [] -> {
      use day <- list.map(
        list.map(dict.values(days), task.async)
        |> list.map(task.await_forever)
        |> list.sort(day_order),
      )

      io.debug(day)
    }

    _ -> panic
  }
}
