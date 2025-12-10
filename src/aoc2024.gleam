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

pub fn main() {
  runner.run(2024, [
    #(01, #(day01.part1, day01.part2)),
    #(02, #(day02.part1, day02.part2)),
    #(03, #(day03.part1, day03.part2)),
    #(04, #(day04.part1, day04.part2)),
    #(05, #(day05.part1, day05.part2)),
    #(06, #(day06.part1, day06.part2)),
    #(09, #(day09.part1, day09.part2)),
    #(14, #(day14.part1, day14.part2)),
    #(15, #(day15.part1, day15.part2)),
    #(17, #(day17.part1, day17.part2)),
  ])
}
