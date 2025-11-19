import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import lib/int/v2.{type V2, V2}
import lib/read

pub fn part1(input: String) -> Int {
  let #(map, moves) = parse(input)

  let assert [start] = {
    use position <- filter_map(map, "@")
    Ok(position)
  }

  int.sum({
    let map = run(map, start, moves)
    use position <- filter_map(map, "O")
    Ok(100 * position.y + position.x)
  })
}

fn filter_map(
  map: Dict(V2, String),
  entity: String,
  then: fn(V2) -> Result(v, Nil),
) -> List(v) {
  use #(position, cell) <- list.filter_map(dict.to_list(map))
  use <- bool.guard(cell != entity, Error(Nil))
  then(position)
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

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(input: String) {
  let assert Ok(#(map, moves)) = string.split_once(input, "\n\n")
  let map = dict.from_list(read.grid(map))

  let moves = {
    let moves = read.fields(string.replace(moves, "\n", ""), "")
    use move <- list.map(moves)

    case move {
      ">" -> V2(1, 0)
      "<" -> V2(-1, 0)
      "^" -> V2(0, -1)
      "v" -> V2(0, 1)
      move -> panic as move
    }
  }

  #(map, moves)
}
