import aoc2021/day01
import aoc2021/day02
import runner

pub fn main() {
  runner.run(2021, [
    #(01, #(day01.part1, day01.part2)),
    #(02, #(day02.part1, day02.part2)),
  ])
}
