import gleam/int
import gleam/iterator
import gleam/list
import gleam/string

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

fn join(input: List(Int)) -> Result(Int, Nil) {
  let iter = iterator.from_list(input)
  case iterator.first(iter), iterator.last(iter) {
    Ok(first), Ok(last) ->
      int.parse(int.to_string(first) <> int.to_string(last))
    _, _ -> Error(Nil)
  }
}

pub fn part1(input: String) -> Int {
  int.sum({
    use line <- list.filter_map(string.split(input, "\n"))
    string.to_graphemes(line)
    |> list.filter_map(int.parse)
    |> join()
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    use line <- list.filter_map(string.split(input, "\n"))
    parse(line, [])
    |> join()
  })
}
