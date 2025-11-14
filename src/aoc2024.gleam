import aoc2024/day01
import aoc2024/day02
import aoc2024/day03
import aoc2024/day04
import runner

pub const days = [
  #(01, #(day01.part1, day01.part2, "inputs/2024/day01.txt")),
  #(02, #(day02.part1, day02.part2, "inputs/2024/day02.txt")),
  #(03, #(day03.part1, day03.part2, "inputs/2024/day03.txt")),
  #(04, #(day04.part1, day04.part2, "inputs/2024/day04.txt")),
]

pub fn main() {
  runner.run(days)
}
