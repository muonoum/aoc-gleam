import gleam/int
import gleam/list
import lib/read

pub fn part1(input: String) -> Int {
  let assert [number] = {
    use #(a, b) <- list.filter_map(
      parse(input)
      |> list.combination_pairs,
    )
    case a + b {
      2020 -> Ok(a * b)
      _else -> Error(Nil)
    }
  }

  number
}

pub fn part2(input: String) -> Int {
  let assert [number] = {
    use group <- list.filter_map(
      parse(input)
      |> list.combinations(3),
    )
    let assert [a, b, c] = group
    case a + b + c {
      2020 -> Ok(a * b * c)
      _else -> Error(Nil)
    }
  }

  number
}

pub fn parse(input: String) {
  read.lines(input)
  |> list.filter_map(int.parse)
}
