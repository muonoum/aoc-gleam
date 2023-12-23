import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/iterator
import gleam/list
import gleam/result
import gleam/set
import lib.{type Vector, Vector}

pub type Tile {
  Start
  Ground
  Pipe(Pipe)
}

pub type Pipe {
  V
  H
  NeL
  NwJ
  Sw7
  SeF
}

pub fn part1(input: String) -> Int {
  let diagram = parse(input)
  let path = get_path(diagram)
  list.length(path) / 2
}

pub fn part2(input: String) -> Int {
  let diagram = parse(input)
  let path = get_path(diagram)
  area(path) - { list.length(path) / 2 } + 1
}

fn area(points: List(Vector)) -> Int {
  let area =
    int.sum({
      use #(current, next) <- list.map(list.window_by_2(points))
      current.x * next.y - current.y * next.x
    })

  int.absolute_value(area) / 2
}

fn get_path(diagram: List(#(Vector, Tile))) -> List(Vector) {
  let pipes =
    dict.from_list({
      use #(position, tile) <- list.filter_map(diagram)
      case tile {
        Pipe(pipe) -> Ok(#(position, pipe))
        _else -> Error(Nil)
      }
    })

  let assert [start_position] = {
    use #(position, tile) <- list.filter_map(diagram)
    use <- bool.guard(Start != tile, Error(Nil))
    Ok(position)
  }

  let assert Ok([start_pipe]) = {
    let candidates = {
      use direction <- list.filter_map(lib.directions)
      let position = lib.add_vectors(start_position, direction)
      use neighbor <- result.try(dict.get(pipes, position))
      let direction = lib.invert_vector(direction)
      use pipes <- result.try(connections(into: neighbor, via: direction))
      Ok(set.from_list(pipes))
    }

    list.reduce(candidates, set.intersection)
    |> result.map(set.to_list)
  }

  let start_neighbors = get_neighbors(start_pipe, start_position, pipes)
  let assert Ok(first_position) = list.first(start_neighbors)

  let path = {
    use #(position, pipes) <- iterator.unfold(#(first_position, pipes))
    use <- bool.guard(position == start_position, iterator.Done)
    let assert Ok(pipe) = dict.get(pipes, position)
    let pipes = dict.delete(pipes, position)
    case get_neighbors(pipe, position, pipes) {
      [] -> iterator.Next(position, #(start_position, pipes))
      [neighbor] -> iterator.Next(position, #(neighbor, pipes))
      _ -> panic
    }
  }

  iterator.to_list(path)
  |> list.prepend(start_position)
  |> list.append([start_position])
}

fn get_neighbors(pipe: Pipe, position: Vector, pipes: Dict(Vector, Pipe)) {
  use direction <- list.filter_map(lib.directions)
  let position = lib.add_vectors(position, direction)
  use neighbor <- result.try(dict.get(pipes, position))
  use candidates <- result.try({
    use pipes <- result.map(connections(into: pipe, via: direction))
    use pipe <- list.filter(pipes)
    pipe == neighbor
  })
  use <- bool.guard(candidates == [], Error(Nil))
  Ok(position)
}

fn connections(
  into pipe: Pipe,
  via direction: Vector,
) -> Result(List(Pipe), Nil) {
  case pipe, direction {
    V, Vector(0, -1) -> Ok([SeF, Sw7, V])
    V, Vector(0, 1) -> Ok([NeL, NwJ, V])
    H, Vector(-1, 0) -> Ok([H, NeL, SeF])
    H, Vector(1, 0) -> Ok([H, NwJ, Sw7])
    NeL, Vector(0, -1) -> Ok([SeF, Sw7, V])
    NeL, Vector(1, 0) -> Ok([H, NwJ, Sw7])
    NwJ, Vector(0, -1) -> Ok([SeF, Sw7, V])
    NwJ, Vector(-1, 0) -> Ok([H, NeL, SeF])
    Sw7, Vector(-1, 0) -> Ok([H, NeL, SeF])
    Sw7, Vector(0, 1) -> Ok([NeL, NwJ, V])
    SeF, Vector(1, 0) -> Ok([H, NwJ, Sw7])
    SeF, Vector(0, 1) -> Ok([NeL, NwJ, V])
    _pipe, _position -> Error(Nil)
  }
}

pub fn parse(input: String) -> List(#(Vector, Tile)) {
  use #(position, grapheme) <- list.map(lib.parse_grid(input))
  #(position, parse_tile(grapheme))
}

fn parse_tile(grapheme: String) -> Tile {
  case grapheme {
    "S" -> Start
    "|" -> Pipe(V)
    "-" -> Pipe(H)
    "L" -> Pipe(NeL)
    "J" -> Pipe(NwJ)
    "7" -> Pipe(Sw7)
    "F" -> Pipe(SeF)
    "." -> Ground
    _ -> panic
  }
}
