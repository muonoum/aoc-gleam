import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import gleam/yielder
import lib/int/vector.{type V2, V2}
import lib/read

pub type Dish {
  Dish(rocks: Rocks, limit: V2)
}

pub type Rocks =
  List(#(V2, Rock))

pub type Rock {
  Rounded
  Cubed
}

pub fn part1(input: String) -> Int {
  int.sum({
    parse(input)
    |> tilt_north
    |> load
  })
}

pub fn part2(input: String) -> Int {
  let dish = parse(input)

  let cycles = 1_000_000_000
  let loop = {
    use seen, #(dish, index) <- yielder.transform(
      yielder.iterate(dish, cycle)
        |> yielder.index,
      dict.new(),
    )

    case dict.get(seen, dish.rocks) {
      Error(Nil) -> {
        let seen = dict.insert(seen, dish.rocks, index + 1)
        yielder.Next(#(dish, seen), seen)
      }

      Ok(previous) -> {
        case { cycles - index } % { previous - index } {
          0 -> yielder.Done
          _ -> yielder.Next(#(dish, seen), seen)
        }
      }
    }
  }

  let assert Ok(#(dish, seen)) = yielder.last(loop)
  let assert Ok(loop) = dict.get(seen, dish.rocks)
  let next = { cycles / loop } * loop

  int.sum(
    load({
      use dish, _ <- list.fold(list.range(next, cycles), dish)
      cycle(dish)
    }),
  )
}

fn cycle(dish: Dish) -> Dish {
  dish
  |> tilt_north
  |> tilt_west
  |> tilt_south
  |> tilt_east
}

fn load(dish: Dish) {
  let Dish(rocks, limit) = dish
  use #(position, rock) <- list.map(rocks)
  use <- bool.guard(rock == Cubed, 0)
  limit.y + 1 - position.y
}

fn tilt_north(dish: Dish) {
  let Dish(rocks, _) = dish

  let rocks = {
    use column <- list.flat_map({
      use column <- list.map(columns(rocks))
      use #(a, _), #(b, _) <- list.sort(column)
      int.compare(a.y, b.y)
    })

    pair.second({
      use y, #(position, rock) <- list.map_fold(column, 0)
      case rock {
        Cubed -> #(position.y + 1, #(position, rock))
        Rounded -> #(y + 1, #(V2(position.x, y), rock))
      }
    })
  }

  Dish(..dish, rocks: rocks)
}

fn tilt_south(dish: Dish) {
  let Dish(rocks, limit) = dish

  let rocks = {
    use group <- list.flat_map({
      use column <- list.map(columns(rocks))
      use #(a, _), #(b, _) <- list.sort(column)
      int.compare(b.y, a.y)
    })

    pair.second({
      use y, #(position, rock) <- list.map_fold(group, limit.y)
      case rock {
        Cubed -> #(position.y - 1, #(position, rock))
        Rounded -> #(y - 1, #(V2(position.x, y), rock))
      }
    })
  }

  Dish(..dish, rocks: rocks)
}

fn tilt_west(dish: Dish) {
  let Dish(rocks, _limit) = dish

  let rocks = {
    use group <- list.flat_map({
      use column <- list.map(rows(rocks))
      use #(a, _), #(b, _) <- list.sort(column)
      int.compare(a.x, b.x)
    })

    pair.second({
      use x, #(position, rock) <- list.map_fold(group, 0)

      case rock {
        Cubed -> #(position.x + 1, #(position, rock))
        Rounded -> #(x + 1, #(V2(x, position.y), rock))
      }
    })
  }

  Dish(..dish, rocks: rocks)
}

fn tilt_east(dish: Dish) {
  let Dish(rocks, limit) = dish

  let rocks = {
    use group <- list.flat_map({
      use column <- list.map(rows(rocks))
      use #(a, _), #(b, _) <- list.sort(column)
      int.compare(b.x, a.x)
    })

    pair.second({
      use x, #(position, rock) <- list.map_fold(group, limit.x)

      case rock {
        Cubed -> #(position.x - 1, #(position, rock))
        Rounded -> #(x - 1, #(V2(x, position.y), rock))
      }
    })
  }

  Dish(..dish, rocks: rocks)
}

fn columns(rocks: Rocks) {
  dict.values({
    use #(position, _) <- list.group(rocks)
    position.x
  })
}

fn rows(rocks: Rocks) {
  dict.values({
    use #(position, _) <- list.group(rocks)
    position.y
  })
}

pub fn parse(input: String) -> Dish {
  let assert [first_line, ..] as lines = read.lines(input)
  let limit = V2(string.length(first_line) - 1, list.length(lines) - 1)

  let rocks = {
    let grid = read.grid(input)
    use #(position, grapheme) <- list.filter_map(grid)
    parse_grapheme(grapheme, position)
  }

  Dish(rocks, limit)
}

fn parse_grapheme(grapheme: String, position: V2) {
  case grapheme {
    "O" -> Ok(#(position, Rounded))
    "#" -> Ok(#(position, Cubed))
    "." -> Error(Nil)
    _else -> panic
  }
}
