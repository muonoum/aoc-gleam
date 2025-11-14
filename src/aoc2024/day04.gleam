import gleam/bool
import gleam/dict.{type Dict}
import gleam/function
import gleam/list
import gleam/result
import lib/int/v2.{type V2}
import lib/read

pub fn part1(input: String) -> Int {
  let grid = parse(input)
  let dict = dict.from_list(grid)

  let x = {
    use #(position, cell) <- list.filter_map(grid)
    use <- bool.guard(cell == "X", Ok(position))
    Error(Nil)
  }

  let xm = {
    use start <- list.flat_map(x)
    use direction <- list.filter_map(v2.directions)
    #(start, direction) |> find(dict, "M")
  }

  let xma = list.filter_map(xm, find(dict, "A"))
  let xmas = list.filter_map(xma, find(dict, "S"))
  list.length(xmas)
}

pub fn part2(_input: String) -> Int {
  -1
}

pub fn find(
  dict: Dict(V2, String),
  target: String,
) -> fn(#(V2, V2)) -> Result(#(V2, V2), Nil) {
  use #(start, direction) <- function.identity
  let position = v2.add(start, direction)
  use neighbor <- result.try(dict.get(dict, position))
  use <- bool.guard(neighbor == target, Ok(#(position, direction)))
  Error(Nil)
}

pub fn parse(input: String) -> List(#(V2, String)) {
  read.grid(input)
}
