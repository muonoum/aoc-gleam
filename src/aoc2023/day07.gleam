import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import lib
import lib/read

pub fn part1(input: String) -> Int {
  play({
    use #(hand, bid) <- list.map(parse(input))
    let number = card_number(_, jokers: False)
    #(hand_number(hand, number), bid, hand_score1(hand))
  })
}

pub fn part2(input: String) -> Int {
  play({
    use #(hand, bid) <- list.map(parse(input))
    let number = card_number(_, jokers: True)
    #(hand_number(hand, number), bid, hand_score2(hand))
  })
}

fn play(hands: List(#(Int, Int, Int))) {
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

fn hand_number(hand: List(String), number: fn(String) -> Int) -> Int {
  let assert Ok(number) =
    list.map(hand, number)
    |> lib.undigits(14)
  number
}

fn card_number(card: String, jokers jokers: Bool) -> Int {
  let shift = case jokers {
    True -> 1
    False -> 0
  }

  case card {
    "A" -> 13
    "K" -> 12
    "Q" -> 11
    "J" if jokers -> 1
    "J" -> 10
    "T" -> 9 + shift
    "9" -> 8 + shift
    "8" -> 7 + shift
    "7" -> 6 + shift
    "6" -> 5 + shift
    "5" -> 4 + shift
    "4" -> 3 + shift
    "3" -> 2 + shift
    "2" -> 1 + shift
    _ -> panic
  }
}

fn hand_score1(hand: List(String)) -> Int {
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

fn hand_score2(hand: List(String)) -> Int {
  let groups = list.group(hand, function.identity)
  let jokers =
    dict.get(groups, "J")
    |> result.map(list.length)
    |> result.unwrap(0)
  let groups =
    dict.drop(groups, ["J"])
    |> dict.values
    |> list.map(list.length)

  case groups, jokers {
    // Five of a kind
    _, 5 -> 7
    [_], _ -> 7
    // Four of a kind
    _, 4 -> 6
    _, 3 -> 6
    [_, _], 2 -> 6
    [3, _], 1 -> 6
    [_, 3], 1 -> 6
    [4, _], _ -> 6
    [_, 4], _ -> 6
    // Full house
    [_, _], _ -> 5
    // Three of a kind
    _, 2 -> 4
    [_, _, _], 1 -> 4
    [3, _, _], _ -> 4
    [_, 3, _], _ -> 4
    [_, _, 3], _ -> 4
    // Two pairs
    [_, _, _], _ -> 3
    // One pair
    [_, _, _, _], _ -> 2
    // High card
    [_, _, _, _, _], _ -> 1
    _, _ -> panic as string.inspect(#(groups, jokers))
  }
}

fn parse(input: String) -> List(#(List(String), Int)) {
  use line <- list.map(read.lines(input))
  let assert [hand, bid] = string.split(line, " ")
  let hand = string.split(hand, "")
  let assert Ok(bid) = int.parse(bid)
  #(hand, bid)
}
