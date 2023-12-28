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
  let row_left_right = visibility1(rows)
  let row_right_left = visibility1(list.map(rows, list.reverse))

  let columns = list.transpose(rows)
  let column_top_down = visibility1(columns)
  let column_bottom_up = visibility1(list.map(columns, list.reverse))

  let trees =
    list.flatten([
      column_top_down,
      column_bottom_up,
      row_left_right,
      row_right_left,
    ])

  list.fold(trees, set.new(), set.union)
  |> set.size
}

pub fn part2(input: String) -> Int {
  let rows = parse(input)
  let row_left = list.map(rows, visibility2)
  let row_right =
    list.map(rows, list.reverse)
    |> list.map(visibility2)
    |> list.map(list.reverse)

  let columns = list.transpose(rows)
  let column_top =
    list.map(columns, visibility2)
    |> list.transpose
  let column_bottom =
    list.map(columns, list.reverse)
    |> list.map(visibility2)
    |> list.map(list.reverse)
    |> list.transpose

  let rows = scenic_score(row_left, row_right)
  let columns = scenic_score(column_top, column_bottom)
  let all = scenic_score(rows, columns)
  let assert Ok(max) =
    list.flatten(all)
    |> list.reduce(int.max)

  max
}

fn visibility1(slice) {
  use trees <- list.map(slice)
  use <- lib.return(pair.second)
  use #(max, seen), #(position, height) <- list.fold(trees, #(-1, set.new()))
  use <- bool.guard(height <= max, #(max, seen))
  #(height, set.insert(seen, position))
}

fn visibility2(slice) {
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

fn scenic_score(a, b) {
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
