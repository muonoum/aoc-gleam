import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/string
import lib/int/v2.{type V2, V2}
import lib/read

pub fn part1(input: String) -> Int {
  let #(map, moves) = parse(input)
  let map = v2.grid(map) |> dict.from_list
  let assert [start] = filter_map(map, "@", Ok)

  int.sum({
    let map = run(map, start, moves)
    use position <- filter_map(map, "O")
    Ok(100 * position.y + position.x)
  })
}

fn run(map: Dict(V2, String), position: V2, moves: List(V2)) -> Dict(V2, String) {
  use <- bool.guard(moves == [], map)
  let assert [move, ..moves] = moves
  let #(map, position) = move_entity(map, position, move)
  run(map, position, moves)
}

fn move_entity(
  map: Dict(V2, String),
  position: V2,
  velocity: V2,
) -> #(Dict(V2, String), V2) {
  let next = v2.add(position, velocity)

  let put = fn(map, entity) {
    dict.insert(map, position, ".")
    |> dict.insert(next, entity)
    |> pair.new(next)
  }

  case dict.get(map, position), dict.get(map, next) {
    Ok("@" as entity), Ok(".") | Ok("O" as entity), Ok(".") -> put(map, entity)

    Ok("@" as entity), Ok("O") | Ok("O" as entity), Ok("O") -> {
      let #(map, next2) = move_entity(map, next, velocity)
      use <- bool.guard(next == next2, #(map, position))
      put(map, entity)
    }

    Ok("@"), Ok("#") | Ok("O"), Ok("#") -> #(map, position)
    _entity, _neighbor -> panic
  }
}

pub fn part2(input: String) -> Int {
  let #(map, moves) = parse(input)
  let map = expand_map(map) |> inspect_map |> v2.grid |> dict.from_list
  let assert [start] = filter_map(map, "@", Ok)

  -1
}

fn inspect_map(map: List(List(String))) -> List(List(String)) {
  list.map(map, string.join(_, "")) |> string.join("\n") |> io.println
  map
}

fn expand_map(map: List(List(String))) -> List(List(String)) {
  use row <- list.map(map)
  use cell <- list.flat_map(row)

  case cell {
    "#" -> ["#", "#"]
    "O" -> ["[", "]"]
    "." -> [".", "."]
    "@" -> ["@", "."]
    _else -> panic as cell
  }
}

fn filter_map(
  map: Dict(V2, a),
  entity: a,
  then: fn(V2) -> Result(b, Nil),
) -> List(b) {
  use #(position, cell) <- list.filter_map(dict.to_list(map))
  use <- bool.guard(cell != entity, Error(Nil))
  then(position)
}

pub fn parse(input: String) {
  let assert Ok(#(map, moves)) = string.split_once(input, "\n\n")
  let map = read.grid(map)

  let moves = {
    let moves = read.fields(string.replace(moves, "\n", ""), "")
    use move <- list.map(moves)

    case move {
      ">" -> V2(1, 0)
      "<" -> V2(-1, 0)
      "^" -> V2(0, -1)
      "v" -> V2(0, 1)
      _else -> panic as move
    }
  }

  #(map, moves)
}
