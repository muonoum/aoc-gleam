import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

pub fn part1(input: String) -> Int {
  let results =
    result.partition({
      use pattern <- list.flat_map(parse(input))
      [reflect(pattern, 100), reflect(list.transpose(pattern), 1)]
    })

  int.sum(pair.first(results))
}

pub fn part2(_input: String) -> Int {
  -1
}

fn reflect(pattern: List(List(String)), multiplier: Int) {
  use index, #(a, b) <- list.fold_until(list.window_by_2(pattern), Error(1))
  let assert Error(index) = index
  use <- bool.guard(a != b, list.Continue(Error(index + 1)))
  let #(before, after) = list.split(pattern, index)

  let bad = {
    use #(before, after) <- list.any(
      list.reverse(before)
      |> list.zip(after),
    )

    before != after
  }

  case bad {
    True -> list.Continue(Error(index + 1))
    False -> list.Stop(Ok(index * multiplier))
  }
}

pub fn parse(input: String) -> List(List(List(String))) {
  let lines = string.split(input, "\n")

  let patterns = {
    list.reverse({
      use patterns, line <- list.fold(lines, [[]])
      let assert [current, ..patterns] = patterns

      case line {
        "" -> [[], list.reverse(current), ..patterns]
        line -> [[string.to_graphemes(line), ..current], ..patterns]
      }
    })
  }

  use pattern <- list.filter_map(patterns)
  use <- bool.guard(pattern == [], Error(Nil))
  Ok(pattern)
}
