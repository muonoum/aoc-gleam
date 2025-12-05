import aoc2015/day01
import aoc2015/day02
import runner

pub fn main() {
  runner.run(2015, [
    #(01, #(day01.part1, day01.part2, "inputs/2015/day01.txt")),
    #(02, #(day02.part1, day02.part2, "inputs/2015/day02.txt")),
  ])
}
