import gleam/int
import gleam/io
import gleam/list
import gleam/set
import gleam/string

fn non_empty(line: String) -> Bool {
  line != ""
}

fn parse(input) {
  use line <- list.map(
    string.split(input, on: "\n")
    |> list.filter(non_empty),
  )

  let assert [id, rest] = string.split(line, ":")
  let assert [_, _id] =
    string.split(id, " ")
    |> list.filter(non_empty)

  let assert [have, want] =
    string.split(rest, "|")
    |> list.map(string.split(_, " "))
    |> list.map(list.filter(_, non_empty))
    |> list.map(list.filter_map(_, int.parse))
    |> list.map(set.from_list)

  set.intersection(have, want)
  |> set.to_list
  |> list.fold(0, fn(sum, _) {
    case sum {
      0 -> 1
      _ -> sum + sum
    }
  })
}

pub fn part1(input: String) {
  parse(input)
  |> int.sum
}

pub fn part2(input: String) {
  parse(input)
  Nil
}
