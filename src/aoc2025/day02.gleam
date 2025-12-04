import gleam/int
import gleam/list
import gleam/regexp
import gleam/string
import lib/read

pub fn part1(input: String) -> Int {
  solve(input, "^(\\d+)\\1$")
}

pub fn part2(input: String) -> Int {
  solve(input, "^(\\d+)\\1+$")
}

fn solve(input: String, pattern: String) -> Int {
  int.sum({
    let assert Ok(pattern) = regexp.from_string(pattern)
    use range <- list.flat_map(parse(input))
    use id <- list.filter(range)
    regexp.check(pattern, int.to_string(id))
  })
}

fn parse(input: String) -> List(List(Int)) {
  use range <- list.map(read.fields(input, ","))
  let assert [first, last] = list.map(string.split(range, "-"), read.integer)
  list.range(first, last)
}
