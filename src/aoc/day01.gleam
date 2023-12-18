import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn part1(input: String) -> Int {
  int.sum({
    use line <- list.filter_map(string.split(input, "\n"))

    join(
      string.to_graphemes(line)
      |> list.filter_map(int.parse),
    )
  })
}

fn join(input: List(Int)) -> Result(Int, Nil) {
  use first <- result.try(list.first(input))
  use last <- result.try(list.last(input))

  int.undigits([first, last], 10)
  |> result.nil_error
}

pub fn part2(input: String) {
  int.sum({
    use line <- list.filter_map(string.split(input, "\n"))
    join(parse(line, []))
  })
}

fn parse(input: String, result: List(Int)) -> List(Int) {
  case input {
    "" -> list.reverse(result)
    "one" <> rest | "1" <> rest -> parse(rest, [1, ..result])
    "two" <> rest | "2" <> rest -> parse(rest, [2, ..result])
    "three" <> rest | "3" <> rest -> parse(rest, [3, ..result])
    "four" <> rest | "4" <> rest -> parse(rest, [4, ..result])
    "five" <> rest | "5" <> rest -> parse(rest, [5, ..result])
    "six" <> rest | "6" <> rest -> parse(rest, [6, ..result])
    "seven" <> rest | "7" <> rest -> parse(rest, [7, ..result])
    "eight" <> rest | "8" <> rest -> parse(rest, [8, ..result])
    "nine" <> rest | "9" <> rest -> parse(rest, [9, ..result])
    _else ->
      string.drop_left(input, 1)
      |> parse(result)
  }
}
