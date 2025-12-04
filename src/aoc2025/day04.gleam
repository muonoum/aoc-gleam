import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import lib/int/v2.{type V2}
import lib/read

pub fn part1(input: String) -> Int {
  parse(input)
  |> unroll
  |> dict.to_list
  |> count("x")
}

pub fn part2(input: String) -> Int {
  parse(input)
  |> run(0)
}

fn run(grid: Dict(V2, String), result: Int) -> Int {
  let grid = unroll(grid)
  let removed = count("x", in: dict.to_list(grid))
  use <- bool.guard(removed == 0, result)
  run(grid, result + removed)
}

fn unroll(grid: Dict(V2, String)) -> Dict(V2, String) {
  use position, cell <- dict.map_values(grid)
  use <- bool.guard(cell == "." || cell == "x", ".")
  let rolls = count("@", in: v2.neighbors(position, grid, v2.directions))
  use <- bool.guard(rolls < 4, "x")
  "@"
}

fn count(in cells: List(#(V2, String)), cell target: String) -> Int {
  use #(_position, cell) <- list.count(cells)
  cell == target
}

pub fn parse(input: String) -> Dict(V2, String) {
  read.grid(input)
  |> v2.grid
  |> dict.from_list
}
