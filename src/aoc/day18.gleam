import gleam/int
import gleam/list
import gleam/string

pub type Direction {
  Right
  Down
  Left
  Up
}

pub type Polygon {
  Polygon(points: List(#(Int, Int)), perimeter: Int)
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
  let Polygon(points, perimeter) = trace(plan)
  let assert Ok(perimeter) = int.divide(perimeter, 2)
  let assert Ok(area) =
    list.window_by_2(points)
    |> list.map(fn(pair) {
      let #(current, next) = pair
      current.0 * next.1 - current.1 * next.0
    })
    |> int.sum
    |> int.divide(2)

  1 + area + perimeter
}

fn trace(plan: Plan) -> Polygon {
  use <- reverse_points
  use state, step <- list.fold(plan, Polygon([#(0, 0)], 0))
  let #(direction, distance) = step
  let points =
    list.prepend(state.points, case state.points, direction {
      [#(x, y), ..], Right -> #(x + distance, y)
      [#(x, y), ..], Down -> #(x, y + distance)
      [#(x, y), ..], Up -> #(x, y - distance)
      [#(x, y), ..], Left -> #(x - distance, y)
      _, _ -> panic
    })

  Polygon(points, state.perimeter + distance)
}

fn reverse_points(poly: fn() -> Polygon) -> Polygon {
  let polygon = poly()
  Polygon(list.reverse(polygon.points), polygon.perimeter)
}

pub fn parse(input: String) {
  use line <- list.map({
    use line <- list.filter(string.split(input, "\n"))
    line != ""
  })

  let assert [direction, distance, code] = string.split(line, " ")
  let direction1 = parse_direction(direction)
  let assert Ok(distance1) = int.parse(distance)
  let #(direction2, distance2) = parse_code(code)

  #(direction1, distance1, direction2, distance2)
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

fn parse_code(code: String) -> #(Direction, Int) {
  let assert [last, ..rest] =
    list.reverse({
      string.to_graphemes(code)
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
