import gleam/int
import gleam/list
import gleam/yielder
import lib
import lib/read

pub fn part1(input: String) -> Int {
  int.sum({
    use history <- list.map(parse(input))
    yielder.iterate(history, diff)
    |> yielder.take_while(list.any(_, lib.non_zero))
    |> yielder.map(list.reverse)
    |> yielder.map(extrapolate(0, _))
    |> yielder.to_list
    |> int.sum
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    use history <- list.map(parse(input))
    yielder.iterate(history, diff)
    |> yielder.take_while(list.any(_, lib.non_zero))
    |> yielder.to_list
    |> list.reverse()
    |> list.fold(0, extrapolate)
  })
}

fn parse(input: String) -> List(List(Int)) {
  use line <- list.map(read.lines(input))
  read.integers(line, " ")
}

fn diff(history: List(Int)) -> List(Int) {
  use #(a, b) <- list.map(list.window_by_2(history))
  b - a
}

fn extrapolate(v: Int, row: List(Int)) -> Int {
  let assert [first, ..] = row
  first - v
}
