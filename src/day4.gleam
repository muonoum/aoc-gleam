import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/set
import gleam/string

fn non_empty(line: String) -> Bool {
  line != ""
}

fn parse(input) {
  use line <- list.filter_map(
    string.split(input, on: "\n")
    |> list.filter(non_empty),
  )

  let assert [id, rest] = string.split(line, ":")
  let assert [_, _id] =
    string.split(id, " ")
    |> list.filter(non_empty)

  let assert [want, have] =
    string.split(rest, "|")
    |> list.map(string.split(_, " "))
    |> list.map(list.filter(_, non_empty))
    |> list.map(list.filter_map(_, int.parse))
    |> list.map(set.from_list)

  let wins =
    set.intersection(want, have)
    |> set.to_list

  use <- bool.guard(when: wins == [], return: Error(Nil))
  Ok(#(id, wins))
}

pub fn part1(input: String) {
  let cards = parse(input)

  int.sum({
    use #(_id, wins) <- list.map(cards)

    list.fold(wins, 0, fn(sum, _) {
      case sum {
        0 -> 1
        _ -> sum + sum
      }
    })
  })
}

pub fn part2(_input: String) {
  Nil
}
