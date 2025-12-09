import aoc2024/day01
import aoc2024/day02
import aoc2024/day03
import aoc2024/day04
import aoc2024/day05
import aoc2024/day06
import aoc2024/day07
import aoc2024/day09
import aoc2024/day10
import aoc2024/day11
import aoc2024/day14
import aoc2024/day15
import aoc2024/day17
import aoc2024/day18
import aoc2024/day19
import aoc2024/day22
import runner

pub fn main() {
  runner.run(2024, [
    #(01, #(day01.part1, day01.part2)),
    #(02, #(day02.part1, day02.part2)),
    #(03, #(day03.part1, day03.part2)),
    #(04, #(day04.part1, day04.part2)),
    #(05, #(day05.part1, day05.part2)),
    #(06, #(day06.part1, day06.part2)),
    #(07, #(day07.part1, day07.part2)),
    #(09, #(day09.part1, day09.part2)),
    #(10, #(day10.part1, day10.part2)),
    #(11, #(day11.part1, day11.part2)),
    #(14, #(day14.part1, day14.part2)),
    #(15, #(day15.part1, day15.part2)),
    #(17, #(day17.part1, day17.part2)),
    #(18, #(day18.part1, day18.part2)),
    #(19, #(day19.part1, day19.part2)),
    #(22, #(day22.part1, day22.part2)),
  ])
}
