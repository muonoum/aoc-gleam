import day1
import day2
import gleam/io
import simplifile

fn day1() {
  let assert Ok(input) = simplifile.read("src/day1.txt")
  io.println("# day1")
  io.debug(#("part1", day1.part1(input)))
  io.debug(#("part2", day1.part2(input)))
}

fn day2() {
  let assert Ok(input) = simplifile.read("src/day2.txt")
  io.println("# day2")
  io.debug(#("part1", day2.part1(input)))
  io.debug(#("part2", day2.part2(input)))
}

pub fn main() {
  day1()
  day2()
}
