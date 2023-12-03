import day1
import day2
import day3
import gleam/io
import gleam/string
import simplifile

fn day1() {
  let assert Ok(input) = simplifile.read("src/day1.txt")
  io.println("# day1")
  io.println("part1: " <> string.inspect(day1.part1(input)))
  io.println("part2: " <> string.inspect(day1.part2(input)))
}

fn day2() {
  let assert Ok(input) = simplifile.read("src/day2.txt")
  io.println("# day2")
  io.println("part1: " <> string.inspect(day2.part1(input)))
  io.println("part2: " <> string.inspect(day2.part2(input)))
}

fn day3() {
  let assert Ok(input) = simplifile.read("src/day3.txt")
  io.println("# day3")
  io.println("part1: " <> string.inspect(day3.part1(input)))
  io.println("part2: " <> string.inspect(day3.part2(input)))
}

pub fn main() {
  day1()
  day2()
  day3()
}
