import gleam/int
import gleam/list
import lib/read

pub fn part1(input: String) -> Int {
  list.map(parse(input), fuel1)
  |> int.sum
}

pub fn part2(input: String) -> Int {
  list.map(parse(input), fuel2(_, 0))
  |> int.sum
}

fn fuel1(mass) {
  mass / 3 - 2
}

fn fuel2(mass, total) {
  case fuel1(mass) {
    v if v <= 0 -> total
    v -> fuel2(v, total + v)
  }
}

fn parse(input: String) {
  read.lines(input)
  |> list.filter_map(int.parse)
}
