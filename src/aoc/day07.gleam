import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/string
import lib

pub fn part1(input: String) -> Int {
  let hands = {
    use #(hand, bid) <- list.map(parse(input))
    #(hand_number(hand), bid, hand_score(hand))
  }

  let groups =
    dict.to_list({
      use #(_hand, _bid, score) <- list.group(hands)
      score
    })

  let groups = {
    use #(score1, _hands), #(score2, _hands) <- list.sort(groups)
    int.compare(score1, score2)
  }

  let bids =
    list.flatten({
      use #(_score, hands) <- list.map(groups)

      let hands = {
        use #(hand1, _bid, _score), #(hand2, _bid, _score) <- list.sort(hands)
        int.compare(hand1, hand2)
      }

      use #(_hand, bid, _score) <- list.map(hands)
      bid
    })

  int.sum({
    use index, bid <- list.index_map(bids)
    bid * { index + 1 }
  })
}

pub fn part2(_input: String) -> Int {
  -1
}

fn parse(input: String) -> List(#(List(String), Int)) {
  use line <- list.map(lib.lines(input))
  let assert [hand, bid] = string.split(line, " ")
  let hand = string.split(hand, "")
  let assert Ok(bid) = int.parse(bid)
  #(hand, bid)
}

fn hand_score(hand: List(String)) -> Int {
  let groups =
    list.group(hand, function.identity)
    |> dict.values()
    |> list.map(list.length)

  case groups {
    // Five of a kind
    [_] -> 7
    // Four of a kind
    [4, _] -> 6
    [_, 4] -> 6
    // Full house
    [_, _] -> 5
    // Three of a kind
    [3, _, _] -> 4
    [_, 3, _] -> 4
    [_, _, 3] -> 4
    // Two pairs
    [_, _, _] -> 3
    // One pair
    [_, _, _, _] -> 2
    // High card
    [_, _, _, _, _] -> 1
    _ -> panic as string.inspect(groups)
  }
}

fn hand_number(hand: List(String)) -> Int {
  let assert Ok(number) =
    list.map(hand, card_number)
    |> int.undigits(14)
  number
}

fn card_number(card: String) -> Int {
  case card {
    "A" -> 13
    "K" -> 12
    "Q" -> 11
    "J" -> 10
    "T" -> 9
    "9" -> 8
    "8" -> 7
    "7" -> 6
    "6" -> 5
    "5" -> 4
    "4" -> 3
    "3" -> 2
    "2" -> 1
    _ -> panic
  }
}
