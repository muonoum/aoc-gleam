import gleam/int
import gleam/bool
import gleam/list
import gleam/pair
import gleam/set.{type Set}
import gleam/string

@external(erlang, "glue", "match")
fn match(string: String, pattern: String) -> List(List(#(Int, Int)))

pub type Position =
  #(Int, Int)

pub type Entity {
  Number(Int, Set(Position), Set(Position))
  Part(String, Position, Set(Position))
}

pub fn part1(input: String) -> Int {
  int.sum({
    list.flatten({
      let #(numbers, parts) =
        list.flatten(parse(input))
        |> list.partition(is_number)

      use number <- list.map(numbers)
      use part <- list.filter_map(parts)
      let assert Number(part_number, _position, area) = number
      let assert Part(_symbol, position, _area) = part

      use <- bool.guard(when: !set.contains(area, position), return: Error(Nil))
      Ok(part_number)
    })
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    let #(numbers, parts) =
      list.flatten(parse(input))
      |> list.partition(is_number)

    use gear <- list.filter_map(list.filter(parts, is_gear))
    let assert Part(_, _position, area) = gear

    try_ratio({
      use number <- list.filter_map(numbers)
      let assert Number(part_number, position, _area) = number

      let adjecent = set.to_list(set.intersection(area, position))
      use <- bool.guard(when: adjecent == [], return: Error(Nil))
      Ok(part_number)
    })
  })
}

fn parse(from input: String) -> List(List(Entity)) {
  use row, line <- list.index_map(
    string.split(input, on: "\n")
    |> list.filter(fn(line) { line != "" }),
  )

  use match <- list.map(match(line, "(?<N>\\d+)(?=[^\\d]|$)|(?<P>[^\\d.])"))

  case match {
    [#(start, length), #(-1, _)] if start >= 0 -> {
      let assert Ok(value) = int.parse(string.slice(line, start, length))
      Number(value, position(row, start, length), area(row, start, length))
    }

    [#(-1, _), #(start, length)] if start >= 0 -> {
      let symbol = string.slice(line, start, length)
      Part(symbol, #(start, row), area(row, start, length))
    }

    _else -> panic
  }
}

fn try_ratio(pair: List(_)) -> Result(Int, Nil) {
  case pair {
    [a, b] -> Ok(a * b)
    _ -> Error(Nil)
  }
}

fn is_number(entity: Entity) -> Bool {
  case entity {
    Number(..) -> True
    _else -> False
  }
}

fn is_gear(entity: Entity) -> Bool {
  case entity {
    Part("*", ..) -> True
    _else -> False
  }
}

fn position(row, start, length) -> Set(Position) {
  list.range(start, start + length - 1)
  |> list.map(pair.new(_, row))
  |> set.from_list
}

fn area(row, start, length) -> Set(Position) {
  set.from_list({
    list.flatten([
      list.range(start - 1, start + length)
      |> list.map(pair.new(_, row - 1)),
      [#(start - 1, row), #(start + length, row)],
      list.range(start - 1, start + length)
      |> list.map(pair.new(_, row + 1)),
    ])
  })
}
