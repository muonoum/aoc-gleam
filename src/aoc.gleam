import aoc/day1
import aoc/day2
import aoc/day3
import aoc/day4
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

fn day_order(a, b) {
  case a, b {
    Day(a, _, _), Day(b, _, _) -> int.compare(a, b)
  }
}

pub fn main() {
  case erlang.start_arguments() {
    ["1"] -> [io.debug(day1())]
    ["2"] -> [io.debug(day2())]
    ["3"] -> [io.debug(day3())]
    ["4"] -> [io.debug(day4())]
    [] -> {
      use day <- list.map(
        list.map([day1, day2, day3, day4], task.async)
        |> list.map(task.await_forever)
        |> list.sort(day_order),
      )

      io.debug(day)
    }

    _ -> panic
  }
}
