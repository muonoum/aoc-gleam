import aoc2025/day01
import aoc2025/day02
import aoc2025/day04
import runner

pub const days = [
  #(01, #(day01.part1, day01.part2, "inputs/2025/day01.txt")),
  #(02, #(day02.part1, day02.part2, "inputs/2025/day02.txt")),
  #(04, #(day04.part1, day04.part2, "inputs/2025/day04.txt")),
]

pub fn main() {
  runner.run(days)
}
