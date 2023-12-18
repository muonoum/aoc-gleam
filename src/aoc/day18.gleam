import gleam/int
import gleam/list
import gleam/string
import lib.{type Vector, Vector}

pub type Direction {
  Right
  Down
  Left
  Up
}

pub type Trench {
  Trench(points: List(Vector), perimeter: Int)
}

pub type Plan =
  List(#(Direction, Int))

pub fn part1(input: String) -> Int {
  run({
    use #(direction, distance, _, _) <- list.map(parse(input))
    #(direction, distance)
  })
}

pub fn part2(input: String) -> Int {
  run({
    use #(_, _, direction, distance) <- list.map(parse(input))
    #(direction, distance)
  })
}

fn run(plan: Plan) -> Int {
  let Trench(points, perimeter) = dig(plan)
  let assert Ok(area) = area(points)
  let assert Ok(perimeter) = int.divide(perimeter, 2)
  area + perimeter + 1
}

fn area(points: List(Vector)) -> Result(Int, Nil) {
  use <- lib.return(int.divide(_, 2))
  use <- lib.return(int.sum)
  use #(current, next) <- list.map(list.window_by_2(points))
  current.x * next.y - current.y * next.x
}

fn dig(plan: Plan) -> Trench {
  use <- reverse_points
  use state, step <- list.fold(plan, Trench([Vector(0, 0)], 0))
  let #(direction, distance) = step
  let points =
    list.prepend(state.points, case direction, state.points {
      Right, [Vector(x, y), ..] -> Vector(x + distance, y)
      Down, [Vector(x, y), ..] -> Vector(x, y + distance)
      Up, [Vector(x, y), ..] -> Vector(x, y - distance)
      Left, [Vector(x, y), ..] -> Vector(x - distance, y)
      _, _ -> panic
    })

  Trench(points, state.perimeter + distance)
}

fn reverse_points(to_trench: fn() -> Trench) -> Trench {
  let trench = to_trench()
  Trench(..trench, points: list.reverse(trench.points))
}

pub fn parse(input: String) {
  use line <- list.map(lib.lines(input))
  let assert [direction, distance, color] = string.split(line, " ")
  let direction1 = parse_direction(direction)
  let assert Ok(distance1) = int.parse(distance)
  let #(direction2, distance2) = parse_color(color)
  #(direction1, distance1, direction2, distance2)
}

fn parse_color(color: String) -> #(Direction, Int) {
  let assert [last, ..rest] =
    list.reverse({
      string.to_graphemes(color)
      |> list.filter_map(int.base_parse(_, 16))
    })

  let assert Ok(distance) =
    list.reverse(rest)
    |> int.undigits(16)

  let direction =
    int.to_string(last)
    |> parse_direction

  #(direction, distance)
}

fn parse_direction(direction: String) -> Direction {
  case direction {
    "R" | "0" -> Right
    "D" | "1" -> Down
    "L" | "2" -> Left
    "U" | "3" -> Up
    _ -> panic
  }
}
