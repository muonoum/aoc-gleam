import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/set.{type Set}
import gleam/string

@external(erlang, "glue", "match")
fn match(string: String, pattern: String) -> List(List(#(Int, Int)))

pub type Position =
  #(Int, Int)

pub type Number {
  Number(Int, Set(Position), Set(Position))
}

pub type Part {
  Part(String, Position, Set(Position))
}

pub type Space {
  Space(numbers: List(Number), parts: List(Part))
}

pub fn part1(input: String) -> Int {
  int.sum({
    list.flatten({
      let Space(numbers, parts) = parse(input)
      use Number(part_number, _, area) <- list.map(numbers)
      use Part(_, position, _) <- list.filter_map(parts)

      let contained = set.contains(area, position)
      use <- bool.guard(!contained, Error(Nil))
      Ok(part_number)
    })
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    let Space(numbers, parts) = parse(input)
    use Part(_, _, area) <- list.filter_map(list.filter(parts, is_gear))

    try_ratio({
      use Number(part_number, position, _) <- list.filter_map(numbers)
      let adjecent = set.to_list(set.intersection(area, position))
      use <- bool.guard(adjecent == [], Error(Nil))
      Ok(part_number)
    })
  })
}

fn parse(from input: String) -> Space {
  use space, string, row <- list.index_fold(
    over: string.split(input, on: "\n")
    |> list.filter(non_empty),
    from: Space(numbers: [], parts: []),
  )

  use space, match <- list.fold(
    over: match(string, "(?<N>\\d+)(?=[^\\d]|$)|(?<P>[^\\d.])"),
    from: space,
  )

  case match {
    [#(start, length), #(-1, _)] if start >= 0 -> {
      let assert Ok(value) = int.parse(string.slice(string, start, length))
      let position = position(row, start, length)
      let area = area(row, start, length)
      let numbers = [Number(value, position, area), ..space.numbers]
      Space(..space, numbers: numbers)
    }

    [#(-1, _), #(start, length)] if start >= 0 -> {
      let symbol = string.slice(string, start, length)
      let area = area(row, start, length)
      let parts = [Part(symbol, #(start, row), area), ..space.parts]
      Space(..space, parts: parts)
    }

    _else -> panic
  }
}

fn try_ratio(pair: List(Int)) -> Result(Int, Nil) {
  case pair {
    [a, b] -> Ok(a * b)
    _ -> Error(Nil)
  }
}

fn non_empty(line: String) -> Bool {
  line != ""
}

fn is_gear(part: Part) -> Bool {
  case part {
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
