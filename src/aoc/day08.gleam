import gleam/bool
import gleam/dict.{type Dict}
import gleam/iterator.{type Iterator}
import gleam/list
import gleam/pair
import gleam/string
import gleam_community/maths/arithmetics
import lib
import lib/read

pub type Network =
  Dict(String, #(String, String))

pub type Direction {
  Left
  Right
}

pub fn part1(input: String) -> Int {
  let #(directions, network) = parse(input)

  pair.first({
    let start = #(0, "AAA")
    use #(count, node), direction <- iterator.fold_until(directions, start)
    case direction, dict.get(network, node) {
      Left, Ok(#("ZZZ", _)) -> list.Stop(#(count + 1, node))
      Right, Ok(#(_, "ZZZ")) -> list.Stop(#(count + 1, node))
      Left, Ok(#(left, _)) -> list.Continue(#(count + 1, left))
      Right, Ok(#(_, right)) -> list.Continue(#(count + 1, right))
      _, Error(_) -> panic
    }
  })
}

pub fn part2(input: String) -> Int {
  let #(directions, network) = parse(input)

  let assert [first, ..rest] = {
    use node <- list.map(
      dict.keys(network)
      |> list.filter(string.ends_with(_, "A")),
    )

    pair.first({
      let start = #(0, node)
      use #(count, node), direction <- iterator.fold_until(directions, start)
      let next = {
        case direction, dict.get(network, node) {
          Left, Ok(#(node, _)) -> node
          Right, Ok(#(_, node)) -> node
          _, Error(_) -> panic
        }
      }

      case string.ends_with(next, "Z") {
        False -> list.Continue(#(count + 1, next))
        True -> list.Stop(#(count + 1, next))
      }
    })
  }

  list.fold(rest, first, arithmetics.lcm)
}

fn parse(input: String) -> #(Iterator(Direction), Network) {
  let lines = read.lines(input)
  let assert [directions, ..lines] = lines
  let directions =
    string.split(directions, "")
    |> list.map(parse_direction)
    |> iterator.from_list()
    |> iterator.cycle

  let network = {
    use network, line <- list.fold(lines, dict.new())
    use <- bool.guard(line == "", network)
    let assert [key, pair] = read.fields(line, "=")
    let assert [left, right] =
      lib.remove(pair, "()")
      |> string.split(",")
      |> list.map(string.trim)
    dict.insert(network, key, #(left, right))
  }

  #(directions, network)
}

fn parse_direction(dir: String) -> Direction {
  case dir {
    "L" -> Left
    "R" -> Right
    _ -> panic
  }
}
