import gleam/bool
import gleam/dict.{type Dict}
import gleam/iterator
import gleam/list
import gleam/pair
import gleam/string
import gleam_community/maths/arithmetics

pub type Network =
  Dict(String, #(String, String))

pub fn part1(input: String) -> Int {
  let #(directions, network) = parse(input)

  pair.first({
    use #(count, node), direction <- iterator.fold_until(
      iterator.from_list(directions)
      |> iterator.cycle,
      #(0, "AAA"),
    )

    case direction, dict.get(network, node) {
      "L", Ok(#("ZZZ", _)) -> list.Stop(#(count + 1, node))
      "R", Ok(#(_, "ZZZ")) -> list.Stop(#(count + 1, node))
      "L", Ok(#(left, _)) -> list.Continue(#(count + 1, left))
      "R", Ok(#(_, right)) -> list.Continue(#(count + 1, right))
      _, _ -> panic
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
      use #(count, node), direction <- iterator.fold_until(
        iterator.from_list(directions)
        |> iterator.cycle,
        #(0, node),
      )

      let next = {
        case direction, dict.get(network, node) {
          "L", Ok(#(node, _)) -> node
          "R", Ok(#(_, node)) -> node
          _, _ -> panic
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
