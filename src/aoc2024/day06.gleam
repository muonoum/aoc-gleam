import gleam/dict.{type Dict}
import gleam/list
import gleam/set.{type Set}
import lib/int/v2.{type V2, V2}
import lib/read

pub fn part1(input: String) -> Int {
  let grid = parse(input)

  let assert Ok(#(position, _)) = {
    use #(_, v) <- list.find(grid)
    v == "^"
  }

  set.size({
    step(
      position:,
      direction: V2(0, -1),
      map: dict.from_list(grid),
      positions: set.from_list([position]),
    )
  })
}

fn step(
  position position: V2,
  direction direction: V2,
  map map: Dict(V2, String),
  positions positions: Set(V2),
) -> Set(V2) {
  let next = v2.add(position, direction)

  case dict.get(map, next) {
    Error(Nil) -> positions

    Ok("#") ->
      V2(x: -direction.y, y: direction.x)
      |> step(position, _, map, positions)

    Ok(_) -> step(next, direction, map, set.insert(positions, next))
  }
}

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(input: String) -> List(#(V2, String)) {
  read.grid(input) |> v2.grid
}
