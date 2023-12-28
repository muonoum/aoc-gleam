import gleam/bool
import gleam/list
import gleam/set
import gleam/string

pub fn part1(input: String) -> Int {
  solve(input, 4)
}

pub fn part2(input: String) -> Int {
  solve(input, 14)
}

fn solve(input: String, size: Int) -> Int {
  let windows = list.window(string.to_graphemes(input), size)
  use count, group <- list.fold_until(windows, 0)
  let group = set.from_list(group)
  use <- bool.guard(set.size(group) != size, list.Continue(count + 1))
  list.Stop(count + size)
}

pub fn parse(_input: String) {
  -1
}
