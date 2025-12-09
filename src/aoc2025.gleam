import aoc2025/day01
import aoc2025/day02
import aoc2025/day04
import aoc2025/day05
import aoc2025/day06
import runner

pub fn main() {
  runner.run(2025, [
    #(01, #(day01.part1, day01.part2)),
    #(02, #(day02.part1, day02.part2)),
    #(04, #(day04.part1, day04.part2)),
    #(05, #(day05.part1, day05.part2)),
    #(06, #(day06.part1, day06.part2)),
  ])
}
