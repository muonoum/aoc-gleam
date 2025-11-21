import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/set
import gleam/string
import lib
import lib/read

pub type Card {
  Card(id: Int, matches: Int)
}

pub fn part1(input: String) -> Int {
  let cards = parse(input)

  int.sum({
    use Card(_id, matches) <- list.map(cards)
    use <- bool.guard(matches == 0, 0)
    lib.power(2, matches - 1)
  })
}

pub fn part2(input: String) -> Int {
  list.length(collect(parse(input)))
}

fn collect(cards: List(Card)) -> List(Card) {
  collect_next(cards, cards, [])
}

fn collect_next(
  cards: List(Card),
  all: List(Card),
  deck: List(Card),
) -> List(Card) {
  let deck = list.fold(cards, deck, list.prepend)

  let wins = {
    use card <- list.flat_map(cards)

    list.split(all, card.id)
    |> pair.second
    |> list.split(card.matches)
    |> pair.first
  }

  use <- bool.guard(wins == [], deck)
  collect_next(wins, all, deck)
}

fn parse(input: String) -> List(Card) {
  use line <- list.map(read.lines(input))
  let assert ["Card" <> id, rest] = string.split(line, ":")
  let assert Ok(id) = int.parse(string.trim(id))

  let assert [want, have] = {
    use part <- list.map(string.split(rest, "|"))
    string.split(part, " ")
    |> list.filter_map(int.parse)
    |> set.from_list
  }

  Card(id, set.size(set.intersection(want, have)))
}
