import gleam/bool
import gleam/dict
import gleam/list
import gleam/set
import lib.{type Vector, Vector}

pub type Tile {
  Garden
  Rock
  Start
}

pub fn part1(input: String) -> Int {
  parse(input)
  |> walk(64)
  |> list.length
}

pub fn part2(_input: String) -> Int {
  -1
}

fn walk(grid, steps) {
  let assert Ok(#(start_position, _)) = {
    use #(_position, tile) <- list.find(grid)
    tile == Start
  }

  let grid = dict.from_list(grid)
  let range = list.reverse(list.range(0, steps))
  use positions, step <- list.fold(range, [start_position])
  use <- bool.guard(step == 0, positions)
  let next =
    set.from_list({
      use position <- list.flat_map(positions)
      use #(neighbor, tile) <- list.filter_map(lib.neighbors(position, grid))
      use <- bool.guard(tile == Rock, Error(Nil))
      Ok(neighbor)
    })

  set.to_list(next)
}

fn parse(input: String) {
  lib.parse_grid(input)
  |> list.map(parse_tile)
}

fn parse_tile(tile: #(Vector, String)) -> #(Vector, Tile) {
  let #(position, grapheme) = tile
  case grapheme {
    "#" -> #(position, Rock)
    "." -> #(position, Garden)
    "S" -> #(position, Start)
    _else -> panic
  }
}
