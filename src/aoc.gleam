import day1
import day2
import day3
import day3_take2
import day4
import gleam/erlang
import gleam/io
import gleam/list
import gleam/otp/task
import gleam/string
import simplifile

fn day1() {
  let assert Ok(input) = simplifile.read("src/day1.txt")
  io.println("day1 part1: " <> string.inspect(day1.part1(input)))
  io.println("day1 part2: " <> string.inspect(day1.part2(input)))
}

fn day2() {
  let assert Ok(input) = simplifile.read("src/day2.txt")
  io.println("day2 part1: " <> string.inspect(day2.part1(input)))
  io.println("day2 part2: " <> string.inspect(day2.part2(input)))
}

fn day3() {
  let assert Ok(input) = simplifile.read("src/day3.txt")
  io.println("day3 part2: " <> string.inspect(day3.part2(input)))
  io.println("day3 part2: " <> string.inspect(day3_take2.part2(input)))
}

fn day4() {
  let assert Ok(input) = simplifile.read("src/day4.txt")
  io.println("day4 part1: " <> string.inspect(day4.part1(input)))
  io.println("day4 part2: " <> string.inspect(day4.part2(input)))
}

fn all() {
  list.map([day1, day2, day3, day4], task.async)
  |> list.map(task.await_forever)
  Nil
}

pub fn main() {
  case erlang.start_arguments() {
    ["1"] -> day1()
    ["2"] -> day2()
    ["3"] -> day3()
    ["4"] -> day4()
    [] -> all()
    _ -> panic
  }
}
