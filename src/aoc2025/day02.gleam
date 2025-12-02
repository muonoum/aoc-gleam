import gleam/int
import gleam/list
import gleam/regexp
import gleam/string
import lib/read

const options = regexp.Options(case_insensitive: False, multi_line: False)

pub fn part1(input: String) -> Int {
  solve(input, "^(\\d+)\\1$")
}

pub fn part2(input: String) -> Int {
  solve(input, "^(\\d+)\\1+$")
}

fn solve(input: String, pattern: String) -> Int {
  int.sum({
    let assert Ok(pattern) = regexp.compile(pattern, options)
    use range <- list.flat_map(parse(input))
    use number <- list.filter(range)
    regexp.check(pattern, int.to_string(number))
  })
}

fn parse(input: String) -> List(List(Int)) {
  use range <- list.map(read.fields(input, ","))
  let assert [start, end] = list.map(string.split(range, "-"), read.integer)
  list.range(start, end)
}
