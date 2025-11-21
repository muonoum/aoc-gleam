import aoc2024/day01
import aoc2024/day02
import aoc2024/day03
import aoc2024/day04
import aoc2024/day05
import aoc2024/day06
import aoc2024/day09
import aoc2024/day14
import aoc2024/day15
import aoc2024/day17
import runner

pub const days = [
  #(01, #(day01.part1, day01.part2, "inputs/2024/day01.txt")),
  #(02, #(day02.part1, day02.part2, "inputs/2024/day02.txt")),
  #(03, #(day03.part1, day03.part2, "inputs/2024/day03.txt")),
  #(04, #(day04.part1, day04.part2, "inputs/2024/day04.txt")),
  #(05, #(day05.part1, day05.part2, "inputs/2024/day05.txt")),
  #(06, #(day06.part1, day06.part2, "inputs/2024/day06.txt")),
  #(09, #(day09.part1, day09.part2, "inputs/2024/day09.txt")),
  #(14, #(day14.part1, day14.part2, "inputs/2024/day14.txt")),
  #(15, #(day15.part1, day15.part2, "inputs/2024/day15.txt")),
  #(17, #(day17.part1, day17.part2, "inputs/2024/day17.txt")),
]

pub fn main() {
  runner.run(days)
}
