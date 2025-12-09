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

pub fn main() {
  runner.run(2022, [
    #(01, #(day01.part1, day01.part2)),
    #(02, #(day02.part1, day02.part2)),
    #(03, #(day03.part1, day03.part2)),
    #(04, #(day04.part1, day04.part2)),
    #(05, #(day05.part1, day05.part2)),
    #(06, #(day06.part1, day06.part2)),
    #(07, #(day07.part1, day07.part2)),
    #(08, #(day08.part1, day08.part2)),
    #(09, #(day09.part1, day09.part2)),
    #(10, #(day10.part1, day10.part2)),
  ])
}
