import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/set.{type Set}
import gleam/string

pub type Card {
  Card(Int, Set(Int), Set(Int))
}

pub fn part1(input: String) -> Int {
  let cards = parse(input)

  int.sum({
    use Card(_id, want, have) <- list.map(cards)

    set.intersection(want, have)
    |> set.to_list
    |> list.fold(0, fn(sum, _) {
      case sum {
        0 -> 1
        _ -> sum + sum
      }
    })
  })
}

pub fn part2(input: String) -> Int {
  let cards = parse(input)

  collect(cards, cards, [])
  |> list.length
}

fn parse(input: String) -> List(Card) {
  use line <- list.map(
    string.split(input, "\n")
    |> list.filter(non_empty),
  )

  let assert Ok(#("Card" <> id, rest)) = string.split_once(line, ":")
  let assert Ok(id) = int.parse(string.trim(id))
  let assert [want, have] = {
    use part <- list.map(string.split(rest, "|"))

    string.split(part, " ")
    |> list.filter_map(int.parse)
    |> set.from_list
  }

  Card(id, want, have)
}

fn collect(cards: List(Card), originals: List(Card), deck: List(Card)) {
  let deck = list.fold(cards, deck, list.prepend)
  let wins = list.flat_map(cards, copies(_, originals))
  use <- bool.guard(wins == [], deck)
  collect(wins, originals, deck)
}

fn copies(card: Card, originals: List(Card)) {
  let Card(id, want, have) = card

  list.split(originals, id)
  |> pair.second
  |> list.split(
    set.intersection(want, have)
    |> set.size,
  )
  |> pair.first
}

fn non_empty(line: String) -> Bool {
  line != ""
}
