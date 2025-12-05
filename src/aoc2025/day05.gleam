import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import lib/read

pub type Range =
  #(Int, Int)

pub fn part1(input: String) -> Int {
  let #(ranges, available) = parse(input)

  list.length({
    use ingredient <- list.filter_map(available)
    check(ingredient, ranges)
  })
}

fn check(value: Int, ranges: List(Range)) -> Result(Int, Nil) {
  case ranges {
    [] -> Error(Nil)
    [#(first, last), ..] if value >= first && value <= last -> Ok(value)
    [_range, ..rest] -> check(value, rest)
  }
}

pub fn part2(input: String) -> Int {
  let #(ranges, _available) = parse(input)

  int.sum({
    let sorted = {
      use #(a, _), #(b, _) <- list.sort(ranges)
      int.compare(a, b)
    }

    let merged = list.fold(sorted, [], merge)
    use #(first, last) <- list.map(merged)
    last + 1 - first
  })
}

fn merge(ranges: List(Range), range: Range) -> List(Range) {
  use <- bool.guard(ranges == [], [range])
  let assert [next, ..rest] = ranges
  use <- bool.guard(range.0 > next.1 || range.1 < next.0, [range, next, ..rest])
  [#(int.min(range.0, next.0), int.max(range.1, next.1)), ..rest]
}

pub fn parse(input: String) -> #(List(Range), List(Int)) {
  let assert Ok(#(ranges, available)) = string.split_once(input, "\n\n")
  let available = read.integers(available, "\n")

  let ranges = {
    use range <- list.map(read.lines(ranges))
    let assert [first, last] = read.integers(range, "-")
    #(first, last)
  }

  #(ranges, available)
}
