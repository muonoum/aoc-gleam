import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/set
import gleam/string
import lib
import lib/int/vector.{V2}
import lib/read

pub fn part1(input: String) -> Int {
  let rows = parse(input)
  let row_left = from_outside(rows)
  let row_right = from_outside(list.map(rows, list.reverse))

  let columns = list.transpose(rows)
  let column_top = from_outside(columns)
  let column_bottom = from_outside(list.map(columns, list.reverse))

  list.flatten([column_top, column_bottom, row_left, row_right])
  |> list.fold(set.new(), set.union)
  |> set.size
}

pub fn part2(input: String) -> Int {
  let rows = parse(input)
  let row_left = list.map(rows, from_inside)
  let row_right =
    list.map(rows, list.reverse)
    |> list.map(from_inside)
    |> list.map(list.reverse)

  let columns = list.transpose(rows)
  let column_top =
    list.map(columns, from_inside)
    |> list.transpose
  let column_bottom =
    list.map(columns, list.reverse)
    |> list.map(from_inside)
    |> list.map(list.reverse)
    |> list.transpose

  let rows = score(row_left, row_right)
  let columns = score(column_top, column_bottom)
  let all = score(rows, columns)
  let assert Ok(max) =
    list.flatten(all)
    |> list.reduce(int.max)

  max
}

fn from_outside(slice) {
  use trees <- list.map(slice)
  use <- lib.return(pair.second)
  use #(max, seen), #(position, height) <- list.fold(trees, #(-1, set.new()))
  use <- bool.guard(height <= max, #(max, seen))
  #(height, set.insert(seen, position))
}

fn from_inside(slice) {
  use _, index <- list.index_map(slice)
  let assert #(neighbors, [#(_, height), ..]) = list.split(slice, index)
  case list.reverse(neighbors) {
    [] -> 0
    neighbors -> {
      use visibility, #(_, neighbor) <- list.fold_until(neighbors, 0)
      use <- bool.guard(neighbor >= height, list.Stop(visibility + 1))
      list.Continue(visibility + 1)
    }
  }
}

fn score(a, b) {
  use #(a, b) <- list.map(list.zip(a, b))
  use #(a, b) <- list.map(list.zip(a, b))
  a * b
}

pub fn parse(input: String) {
  use line, y <- list.index_map(read.lines(input))
  use height, x <- list.index_map(string.to_graphemes(line))
  let assert Ok(height) = int.parse(height)
  #(V2(x, y), height)
}
