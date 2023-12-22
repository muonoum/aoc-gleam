import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import lib.{type Vector, Vector}

pub type Dish {
  Dish(rocks: Rocks, limit: Vector)
}

pub type Rocks =
  List(#(Vector, Rock))

pub type Rock {
  Rounded
  Cubed
}

pub fn part1(input: String) -> Int {
  int.sum({
    parse(input)
    |> tilt_north
    |> calculate_load
  })
}

pub fn part2(_input: String) -> Int {
  -1
}

fn calculate_load(dish: Dish) {
  let Dish(rocks, limit) = dish
  use #(position, rock) <- list.map(rocks)
  use <- bool.guard(rock == Cubed, 0)
  limit.y + 1 - position.y
}

fn tilt_north(dish: Dish) {
  let Dish(rocks, _) = dish

  let rocks = {
    use column <- list.flat_map(columns(rocks))
    pair.second({
      use y, #(position, rock) <- list.map_fold(column, 0)
      case rock {
        Cubed -> #(position.y + 1, #(position, rock))
        Rounded -> #(y + 1, #(Vector(position.x, y), rock))
      }
    })
  }

  Dish(..dish, rocks: rocks)
}

fn columns(rocks: Rocks) {
  let columns =
    dict.values({
      use #(position, _) <- list.group(rocks)
      position.x
    })

  use column <- list.map(columns)
  use #(a, _), #(b, _) <- list.sort(column)
  int.compare(a.y, b.y)
}

pub fn parse(input: String) -> Dish {
  let assert [first_line, ..] as lines = lib.lines(input)
  let limit = Vector(string.length(first_line) - 1, list.length(lines) - 1)

  let rocks = {
    let grid = lib.parse_grid(input)
    use #(position, grapheme) <- list.filter_map(grid)
    parse_grapheme(grapheme, position)
  }

  Dish(rocks, limit)
}

fn parse_grapheme(grapheme: String, position: Vector) {
  case grapheme {
    "O" -> Ok(#(position, Rounded))
    "#" -> Ok(#(position, Cubed))
    "." -> Error(Nil)
    _else -> panic
  }
}
