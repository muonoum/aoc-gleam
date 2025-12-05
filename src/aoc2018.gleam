import aoc2018/day01
import aoc2018/day02
import runner

pub const days = [
  #(01, #(day01.part1, day01.part2, "inputs/2018/day01.txt")),
  #(02, #(day02.part1, day02.part2, "inputs/2018/day02.txt")),
]

pub fn main() {
  runner.run(2018, days)
}
