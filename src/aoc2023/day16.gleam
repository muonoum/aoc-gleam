import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/set.{type Set}
import gleam/string
import gleam/yielder
import lib/int/v2.{type V2, V2}
import lib/read

pub type Space {
  Space(cells: Dict(V2, Cell), limit: V2)
}

pub type Cell {
  EmptySpace
  LeftMirror
  RightMirror
  HorizontalSplit
  VerticalSplit
}

pub type Light {
  Light(position: V2, velocity: V2)
}

pub type State {
  State(lights: Set(Light), energy: Set(Light))
}

pub fn part1(input: String) -> Int {
  let space = parse(input)
  let start = Light(V2(0, 0), V2(1, 0))
  energize(space, start)
}

pub fn part2(input: String) -> Int {
  let space = parse(input)

  let horizontal = {
    use x <- list.flat_map(list.range(0, space.limit.x))
    let top = Light(V2(x, 0), V2(0, 1))
    let bottom = Light(V2(x, space.limit.y), V2(0, -1))
    [top, bottom]
  }

  let vertical = {
    use y <- list.flat_map(list.range(0, space.limit.y))
    let left = Light(V2(0, y), V2(1, 0))
    let right = Light(V2(space.limit.x, y), V2(-1, 0))
    [left, right]
  }

  let starts = set.from_list(list.flatten([horizontal, vertical]))
  use max, start <- set.fold(starts, 0)
  int.max(max, energize(space, start))
}

fn energize(space: Space, start: Light) -> Int {
  let states = {
    let initial_state = State(lights: set.from_list([start]), energy: set.new())
    use state <- yielder.iterate(from: initial_state)
    use State(lights, energy), light <- set.fold(state.lights, from: state)

    let lights = set.delete(lights, light)
    use <- bool.guard(set.contains(energy, light), State(lights, energy))
    State(move(light, space, lights), set.insert(energy, light))
  }

  use _, State(lights, energy) <- yielder.fold_until(over: states, from: 0)
  use <- bool.guard(set.size(lights) != 0, list.Continue(0))
  list.Stop(count_energy(energy))
}

fn count_energy(energy: Set(Light)) -> Int {
  set.to_list(energy)
  |> list.map(fn(light) { light.position })
  |> set.from_list
  |> set.size
}

fn add_vectors(a: V2, b: V2, limit: V2) -> Result(V2, Nil) {
  case a.x + b.x, a.y + b.y {
    x, _ if x < 0 || x > limit.x -> Error(Nil)
    _, y if y < 0 || y > limit.y -> Error(Nil)
    x, y -> Ok(V2(x, y))
  }
}

fn split_horizontal(velocity: V2) -> List(V2) {
  case velocity {
    V2(x, y) if x == 0 -> [V2(-y, 0), V2(y, 0)]
    V2(x, y) if y == 0 -> [V2(x, y)]
    _ -> panic
  }
}

fn split_vertical(velocity: V2) -> List(V2) {
  case velocity {
    V2(x, y) if x == 0 -> [V2(x, y)]
    V2(x, y) if y == 0 -> [V2(0, -x), V2(0, x)]
    _ -> panic
  }
}

fn move(light: Light, space: Space, lights: Set(Light)) {
  let assert Ok(cell) = dict.get(space.cells, light.position)
  let update = fn(lights, velocity) {
    case add_vectors(light.position, velocity, space.limit) {
      Ok(position) -> set.insert(lights, Light(position, velocity))
      Error(Nil) -> lights
    }
  }

  case cell {
    EmptySpace -> update(lights, light.velocity)
    LeftMirror -> update(lights, V2(light.velocity.y, light.velocity.x))
    RightMirror -> update(lights, V2(-light.velocity.y, -light.velocity.x))
    HorizontalSplit ->
      split_horizontal(light.velocity)
      |> list.fold(from: lights, with: update)
    VerticalSplit ->
      split_vertical(light.velocity)
      |> list.fold(from: lights, with: update)
  }
}

fn parse(input: String) {
  let assert [first_line, ..] as lines = read.lines(input)
  let limit = V2(string.length(first_line) - 1, list.length(lines) - 1)
  let cells =
    list.index_map(lines, parse_line)
    |> list.flatten
    |> dict.from_list
  Space(cells, limit)
}

fn parse_line(line: String, row: Int) -> List(#(V2, Cell)) {
  use grapheme, column <- list.index_map(read.fields(line, ""))
  let cell = parse_cell(grapheme)
  let position = V2(column, row)
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
