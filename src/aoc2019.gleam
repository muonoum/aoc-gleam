import aoc2019/day01
import aoc2019/day02
import aoc2019/day03
import runner

pub fn main() {
  runner.run(2019, [
    #(01, #(day01.part1, day01.part2)),
    #(02, #(day02.part1, day02.part2)),
    #(03, #(day03.part1, day03.part2)),
  ])
}
