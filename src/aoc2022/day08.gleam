import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/set
import gleam/string
import lib
import lib/read
import lib/int/vector.{V2}

fn check(slice) {
  use trees <- list.map(slice)
  use <- lib.return(pair.second)
  use #(max, seen), #(position, height) <- list.fold(trees, #(-1, set.new()))
  use <- bool.guard(height <= max, #(max, seen))
  #(height, set.insert(seen, position))
}

pub fn part1(input: String) -> Int {
  let rows = parse(input)
  let row_left_right = check(rows)
  let row_right_left = check(list.map(rows, list.reverse))

  let columns = list.transpose(rows)
  let column_top_down = check(columns)
  let column_bottom_up = check(list.map(columns, list.reverse))

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

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(input: String) {
  use line, y <- list.index_map(read.lines(input))
  use height, x <- list.index_map(string.to_graphemes(line))
  let assert Ok(height) = int.parse(height)
  #(V2(x, y), height)
}
