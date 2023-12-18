import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/pair
import gleam/set
import gleam/string

pub type Card {
  Card(id: Int, matches: Int)
}

pub fn part1(input: String) -> Int {
  let cards = parse(input)

  int.sum({
    use Card(_id, matches) <- list.map(cards)
    use <- bool.guard(matches == 0, 0)
    let assert Ok(points) = int.power(2, int.to_float(matches - 1))
    float.round(points)
  })
}

pub fn part2(input: String) -> Int {
  parse(input)
  |> collect
  |> list.length
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
  use line <- list.map({
    use line <- list.filter(string.split(input, "\n"))
    line != ""
  })

  let assert ["Card" <> id, rest] = string.split(line, ":")
  let assert Ok(id) = int.parse(string.trim(id))
  let assert [want, have] = {
    use part <- list.map(string.split(rest, "|"))

    string.split(part, " ")
    |> list.filter_map(int.parse)
    |> set.from_list
  }

  let matches =
    set.intersection(want, have)
    |> set.size

  Card(id, matches)
}
