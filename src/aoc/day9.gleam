import gleam/bool
import gleam/int
import gleam/io
import gleam/iterator
import gleam/list
import gleam/string

pub fn part1(input: String) -> Int {
  int.sum({
    use history <- list.map(parse(input))
    iterator.iterate(history, fn(history) {
      use #(a, b) <- list.map(list.window_by_2(history))
      b - a
    })
    |> iterator.take_while(list.any(_, fn(v) { v != 0 }))
    |> iterator.map(list.reverse)
    |> iterator.map(fn(row) {
      let assert [n, ..] = row
      n
    })
    |> iterator.to_list
    |> int.sum
  })
}

pub fn part2(_input: String) -> Int {
  -1
}

fn parse(input: String) -> List(List(Int)) {
  let lines = string.split(input, "\n")
  use line <- list.filter_map(lines)
  use <- bool.guard(line == "", Error(Nil))

  string.split(line, " ")
  |> list.filter_map(int.parse)
  |> Ok
}
