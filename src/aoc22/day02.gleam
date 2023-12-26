import gleam/int
import gleam/list
import lib/read

pub type Hand {
  Paper
  Rock
  Scissor
}

pub type Outcome {
  Draw
  Win
  Lose
}

pub fn part1(input: String) -> Int {
  int.sum({
    use #(opponents, #(mine, _)) <- list.map(parse(input))
    score_match(opponents, mine)
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    use #(opponents, #(_, outcome)) <- list.map(parse(input))
    score_match(opponents, select_hand(opponents, outcome))
  })
}

fn select_hand(opponents: Hand, outcome: Outcome) -> Hand {
  case opponents, outcome {
    Paper, Draw -> Paper
    Paper, Win -> Scissor
    Paper, Lose -> Rock
    Rock, Draw -> Rock
    Rock, Win -> Paper
    Rock, Lose -> Scissor
    Scissor, Draw -> Scissor
    Scissor, Win -> Rock
    Scissor, Lose -> Paper
  }
}

fn score_match(opponents: Hand, mine: Hand) -> Int {
  case opponents, mine {
    Paper, Rock -> 1 + 0
    Rock, Rock -> 1 + 3
    Scissor, Rock -> 1 + 6
    Scissor, Paper -> 2 + 0
    Paper, Paper -> 2 + 3
    Rock, Paper -> 2 + 6
    Rock, Scissor -> 3 + 0
    Scissor, Scissor -> 3 + 3
    Paper, Scissor -> 3 + 6
  }
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))
  let assert [opponents, mine] = read.fields(line, " ")
  #(parse_opponents(opponents), parse_mine(mine))
}

fn parse_opponents(grapheme: String) -> Hand {
  case grapheme {
    "A" -> Rock
    "B" -> Paper
    "C" -> Scissor
    _else -> panic
  }
}

fn parse_mine(grapheme: String) -> #(Hand, Outcome) {
  case grapheme {
    "X" -> #(Rock, Lose)
    "Y" -> #(Paper, Draw)
    "Z" -> #(Scissor, Win)
    _else -> panic
  }
}
