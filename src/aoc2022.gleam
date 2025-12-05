import aoc2022/day01
import aoc2022/day02
import aoc2022/day03
import aoc2022/day04
import aoc2022/day05
import aoc2022/day06
import aoc2022/day07
import aoc2022/day08
import aoc2022/day09
import aoc2022/day10
import runner

pub const days = [
  #(01, #(day01.part1, day01.part2, "inputs/2022/day01.txt")),
  #(02, #(day02.part1, day02.part2, "inputs/2022/day02.txt")),
  #(03, #(day03.part1, day03.part2, "inputs/2022/day03.txt")),
  #(04, #(day04.part1, day04.part2, "inputs/2022/day04.txt")),
  #(05, #(day05.part1, day05.part2, "inputs/2022/day05.txt")),
  #(06, #(day06.part1, day06.part2, "inputs/2022/day06.txt")),
  #(07, #(day07.part1, day07.part2, "inputs/2022/day07.txt")),
  #(08, #(day08.part1, day08.part2, "inputs/2022/day08.txt")),
  #(09, #(day09.part1, day09.part2, "inputs/2022/day09.txt")),
  #(10, #(day10.part1, day10.part2, "inputs/2022/day10.txt")),
]

pub fn main() {
  runner.run(2022, days)
}
