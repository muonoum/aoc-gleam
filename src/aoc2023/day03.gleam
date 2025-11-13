import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/set.{type Set}
import gleam/string
import lib/read

pub type Position =
  #(Int, Int)

pub type Number {
  Number(Int, Set(Position), Set(Position))
}

pub type Part {
  Part(String, Position, Set(Position))
}

pub type Schematic {
  Schematic(List(Number), List(Part))
}

pub type Token {
  Digits(String, Int)
  Dot(Int)
  Symbol(String, Int)
}

pub fn part1(input: String) -> Int {
  int.sum({
    list.flatten({
      let Schematic(numbers, parts) = parse(input)
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
    let Schematic(numbers, parts) = parse(input)
    use Part(_, _, area) <- list.filter_map(list.filter(parts, is_gear))

    try_ratio({
      use Number(part_number, position, _) <- list.filter_map(numbers)
      let adjecent = set.to_list(set.intersection(area, position))
      use <- bool.guard(adjecent == [], Error(Nil))
      Ok(part_number)
    })
  })
}

fn parse(from input: String) -> Schematic {
  use state, tokens, row <- list.index_fold(from: Schematic([], []), over: {
    use line <- list.map(read.lines(input))
    string.to_graphemes(line)
    |> list.index_fold([], parse_grapheme)
    |> list.reverse
  })

  use Schematic(numbers, parts), token <- list.fold(tokens, state)

  case token {
    Dot(_) -> Schematic(numbers, parts)

    Digits(digits, column) -> {
      let assert Ok(number) = int.parse(digits)
      let length = string.length(digits)
      let position = position(row, column, length)
      let area = area(row, column, length)
      let numbers = [Number(number, position, area), ..numbers]
      Schematic(numbers, parts)
    }

    Symbol(symbol, column) -> {
      let area = area(row, column, 1)
      let parts = [Part(symbol, #(column, row), area), ..parts]
      Schematic(numbers, parts)
    }
  }
}

fn parse_grapheme(
  tokens: List(Token),
  grapheme: String,
  column: Int,
) -> List(Token) {
  case grapheme {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ->
      append_digit(tokens, grapheme, column)
    "." -> [Dot(column), ..tokens]
    symbol -> [Symbol(symbol, column), ..tokens]
  }
}

fn append_digit(tokens: List(Token), digit: String, column: Int) -> List(Token) {
  case tokens {
    [Digits(digits, column), ..tokens] -> {
      [Digits(digits <> digit, column), ..tokens]
    }
    _else -> [Digits(digit, column), ..tokens]
  }
}

fn try_ratio(pair: List(Int)) -> Result(Int, Nil) {
  case pair {
    [a, b] -> Ok(a * b)
    _ -> Error(Nil)
  }
}

fn is_gear(part: Part) -> Bool {
  case part {
    Part("*", ..) -> True
    _else -> False
  }
}

fn position(row, column, length) -> Set(Position) {
  list.range(column, column + length - 1)
  |> list.map(pair.new(_, row))
  |> set.from_list
}

fn area(row, column, length) -> Set(Position) {
  set.from_list({
    list.flatten([
      list.range(column - 1, column + length)
        |> list.map(pair.new(_, row - 1)),
      [#(column - 1, row), #(column + length, row)],
      list.range(column - 1, column + length)
        |> list.map(pair.new(_, row + 1)),
    ])
  })
}
