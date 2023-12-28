import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import lib

pub fn part1(input: String) -> Int {
  let patterns = parse(input)

  let rows = {
    use rows <- list.filter_map(patterns)
    mirror(rows, 100)
  }

  let columns = {
    use rows <- list.filter_map(patterns)
    mirror(list.transpose(rows), 1)
  }

  list.flatten([rows, columns])
  |> int.sum
}

pub fn part2(_input: String) -> Int {
  -1
}

fn mirror(pattern: List(List(String)), multiplier: Int) -> Result(Int, Nil) {
  use <- lib.return(result.nil_error)
  use index, #(a, b) <- list.fold_until(list.window_by_2(pattern), Error(1))
  let assert Error(index) = index
  use <- bool.guard(a != b, list.Continue(Error(index + 1)))

  let #(before, after) = list.split(pattern, index)
  let bad =
    list.reverse(before)
    |> list.zip(after)
    |> list.any(fn(pair) {
      let #(before, after) = pair
      before != after
    })

  use <- bool.guard(bad, list.Continue(Error(index + 1)))
  list.Stop(Ok(index * multiplier))
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
