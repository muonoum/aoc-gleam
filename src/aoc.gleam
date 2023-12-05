import day1
import day2
import day3
import day4
import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/task
import simplifile

fn day1() {
  let assert Ok(input) = simplifile.read("src/day1.txt")
  #(1, day1.part1(input), day1.part2(input))
}

fn day2() {
  let assert Ok(input) = simplifile.read("src/day2.txt")
  #(2, day2.part1(input), day2.part2(input))
}

fn day3() {
  let assert Ok(input) = simplifile.read("src/day3.txt")
  #(3, day3.part1(input), day3.part2(input))
}

fn day4() {
  let assert Ok(input) = simplifile.read("src/day4.txt")
  #(4, day4.part1(input), -1)
}

fn day_order(a, b) {
  case a, b {
    #(a, _, _), #(b, _, _) -> int.compare(a, b)
  }
}

pub fn main() {
  case erlang.start_arguments() {
    ["1"] -> [day1()]
    ["2"] -> [day2()]
    ["3"] -> [day3()]
    ["4"] -> [day4()]

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
