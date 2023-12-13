import gleam/bool
import gleam/dict
import gleam/iterator
import gleam/list
import gleam/pair
import gleam/string

fn navigate(network, start, directions) -> Int {
  pair.first({
    use #(count, key), direction <- iterator.fold_until(
      iterator.from_list(directions)
      |> iterator.cycle,
      #(0, start),
    )

    case direction, dict.get(network, key) {
      "L", Ok(#("ZZZ", _)) -> list.Stop(#(count + 1, key))
      "R", Ok(#(_, "ZZZ")) -> list.Stop(#(count + 1, key))
      "L", Ok(#(next, _)) -> list.Continue(#(count + 1, next))
      "R", Ok(#(_, next)) -> list.Continue(#(count + 1, next))
      _, _ -> panic
    }
  })
}

pub fn part1(input: String) -> Int {
  let #(directions, network) = parse(input)
  navigate(network, "AAA", directions)
}

pub fn part2(_input: String) -> Int {
  -1
}

fn parse(input) {
  let lines = string.split(input, "\n")
  let assert [directions, ..lines] = lines
  let directions = string.split(directions, "")

  let network = {
    use network, line <- list.fold(lines, dict.new())
    use <- bool.guard(line == "", network)

    let assert [key, pair] =
      string.split(line, "=")
      |> list.map(string.trim)

    let assert [left, right] =
      string.replace(pair, "(", "")
      |> string.replace(")", "")
      |> string.split(",")
      |> list.map(string.trim)

    dict.insert(network, key, #(left, right))
  }

  #(directions, network)
}
