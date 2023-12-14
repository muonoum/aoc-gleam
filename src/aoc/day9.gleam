import gleam/bool
import gleam/int
import gleam/iterator
import gleam/list
import gleam/string

pub fn part1(input: String) -> Int {
  int.sum({
    use history <- list.map(parse(input))
    iterator.iterate(history, diff)
    |> iterator.take_while(list.any(_, not_zero))
    |> iterator.map(list.reverse)
    |> iterator.map(extrapolate(0, _))
    |> iterator.to_list
    |> int.sum
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    use history <- list.map(parse(input))
    iterator.iterate(history, diff)
    |> iterator.take_while(list.any(_, not_zero))
    |> iterator.to_list
    |> list.reverse()
    |> list.fold(0, extrapolate)
  })
}

fn parse(input: String) -> List(List(Int)) {
  let lines = string.split(input, "\n")
  use line <- list.filter_map(lines)
  use <- bool.guard(line == "", Error(Nil))

  string.split(line, " ")
  |> list.filter_map(int.parse)
  |> Ok
}

fn not_zero(v) {
  v != 0
}

fn diff(history: List(Int)) -> List(Int) {
  use #(a, b) <- list.map(list.window_by_2(history))
  b - a
}

fn extrapolate(left, row) {
  let assert [first, ..] = row
  first - left
}
