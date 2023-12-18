import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/iterator
import gleam/list
import gleam/set.{type Set}
import gleam/string
import lib.{type Vector, Vector}

pub type Space {
  Space(cells: Dict(Vector, Cell), limit: Vector)
}

pub type Cell {
  EmptySpace
  LeftMirror
  RightMirror
  HorizontalSplit
  VerticalSplit
}

pub type Light {
  Light(position: Vector, momentum: Vector)
}

pub type State {
  State(lights: Set(Light), energy: Set(Light))
}

pub fn part1(input: String) -> Int {
  let space = parse(input)
  let start = Light(Vector(0, 0), Vector(1, 0))
  energize(space, start)
}

pub fn part2(input: String) -> Int {
  let space = parse(input)

  let horizontal = {
    use x <- list.flat_map(list.range(0, space.limit.x))
    let top = Light(Vector(x, 0), Vector(0, 1))
    let bottom = Light(Vector(x, space.limit.y), Vector(0, -1))
    [top, bottom]
  }

  let vertical = {
    use y <- list.flat_map(list.range(0, space.limit.y))
    let left = Light(Vector(0, y), Vector(1, 0))
    let right = Light(Vector(space.limit.x, y), Vector(-1, 0))
    [left, right]
  }

  let starts = set.from_list(list.flatten([horizontal, vertical]))
  use max, start <- set.fold(starts, 0)
  int.max(max, energize(space, start))
}

fn energize(space: Space, start: Light) -> Int {
  let states = {
    let initial_state = State(lights: set.from_list([start]), energy: set.new())
    use state <- iterator.iterate(from: initial_state)
    use State(lights, energy), light <- set.fold(state.lights, from: state)

    let lights = set.delete(lights, light)
    use <- bool.guard(set.contains(energy, light), State(lights, energy))
    State(move(light, space, lights), set.insert(energy, light))
  }

  use _, State(lights, energy) <- iterator.fold_until(over: states, from: 0)
  use <- bool.guard(set.size(lights) != 0, list.Continue(0))
  list.Stop(count_energy(energy))
}

fn count_energy(energy: Set(Light)) -> Int {
  set.to_list(energy)
  |> list.map(fn(light) { light.position })
  |> set.from_list
  |> set.size
}

fn add_vectors(a: Vector, b: Vector, limit: Vector) -> Result(Vector, Nil) {
  case Vector(a.x + b.x, a.y + b.y) {
    Vector(x, _) if x < 0 || x > limit.x -> Error(Nil)
    Vector(_, y) if y < 0 || y > limit.y -> Error(Nil)
    position -> Ok(position)
  }
}

fn split_horizontal(momentum: Vector) -> List(Vector) {
  case momentum {
    Vector(x, y) if x == 0 -> [Vector(-y, 0), Vector(y, 0)]
    Vector(x, y) if y == 0 -> [Vector(x, y)]
    _ -> panic
  }
}

fn split_vertical(momentum: Vector) -> List(Vector) {
  case momentum {
    Vector(x, y) if x == 0 -> [Vector(x, y)]
    Vector(x, y) if y == 0 -> [Vector(0, -x), Vector(0, x)]
    _ -> panic
  }
}

fn move(light: Light, space: Space, lights: Set(Light)) {
  let assert Ok(cell) = dict.get(space.cells, light.position)
  let update = fn(lights, momentum) {
    case add_vectors(light.position, momentum, space.limit) {
      Ok(position) -> set.insert(lights, Light(position, momentum))
      Error(Nil) -> lights
    }
  }

  case cell {
    EmptySpace -> update(lights, light.momentum)
    LeftMirror -> update(lights, Vector(light.momentum.y, light.momentum.x))
    RightMirror -> update(lights, Vector(-light.momentum.y, -light.momentum.x))
    HorizontalSplit ->
      split_horizontal(light.momentum)
      |> list.fold(from: lights, with: update)
    VerticalSplit ->
      split_vertical(light.momentum)
      |> list.fold(from: lights, with: update)
  }
}

fn parse(input: String) {
  let assert [first_line, ..] as lines = {
    use line <- list.filter(string.split(input, "\n"))
    line != ""
  }

  let limit = Vector(string.length(first_line) - 1, list.length(lines) - 1)
  let cells =
    list.index_map(lines, parse_line)
    |> list.flatten
    |> dict.from_list
  Space(cells, limit)
}

fn parse_line(row: Int, line: String) -> List(#(Vector, Cell)) {
  use column, grapheme <- list.index_map(string.split(line, ""))
  let cell = parse_cell(grapheme)
  let position = Vector(column, row)
  #(position, cell)
}

fn parse_cell(grapheme: String) -> Cell {
  case grapheme {
    "." -> EmptySpace
    "\\" -> LeftMirror
    "/" -> RightMirror
    "-" -> HorizontalSplit
    "|" -> VerticalSplit
    _unknown -> panic
  }
}
