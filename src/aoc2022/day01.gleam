import gleam/int
import gleam/list
import gleam/string

pub fn part1(input: String) -> Int {
  list.fold(parse(input), 0, int.max)
}

pub fn part2(input: String) -> Int {
  parse(input)
  |> list.sort(int.compare)
  |> list.reverse
  |> list.take(3)
  |> int.sum
}

pub fn parse(input: String) -> List(Int) {
  use inventory, line <- list.fold(string.split(input, "\n"), [])

  case int.parse(line), inventory {
    Error(Nil), _ -> [0, ..inventory]
    Ok(calories), [] -> [calories]
    Ok(calories), [sum, ..rest] -> [sum + calories, ..rest]
  }
}
