import gleam/int
import gleam/list
import gleam/result
import gleam/string
import lib

pub fn part1(input: String) {
  int.sum({
    use #(id, all) <- list.filter_map(parse(input))

    let possible = {
      use set <- list.try_map(all)
      use #(color, count) <- list.try_map(set)

      case color, count {
        "red", count if count > 12 -> Error(Nil)
        "green", count if count > 13 -> Error(Nil)
        "blue", count if count > 14 -> Error(Nil)
        _other, _wise -> Ok(#(color, count))
      }
    }

    result.replace(possible, id)
  })
}

pub fn part2(input: String) {
  int.sum({
    use #(_id, sets) <- list.map(parse(input))

    let #(r, g, b) = {
      use result, set <- list.fold(over: sets, from: #(0, 0, 0))
      use #(r, g, b), #(color, count) <- list.fold(over: set, from: result)

      case color {
        "red" if count > r -> #(count, g, b)
        "green" if count > g -> #(r, count, b)
        "blue" if count > b -> #(r, g, count)
        _else -> #(r, g, b)
      }
    }

    r * g * b
  })
}

fn parse(input: String) -> List(#(Int, List(List(#(String, Int))))) {
  use line <- list.map(lib.lines(input))

  let assert [id, game] = string.split(line, on: ":")
  let assert [_, id] = string.split(id, on: " ")
  let assert Ok(id) = int.parse(id)

  let sets = {
    use sets <- list.map(string.split(game, on: ";"))
    use set <- list.map(string.split(sets, on: ","))

    let assert [count, color] = string.split(string.trim(set), on: " ")
    let assert Ok(count) = int.parse(count)
    #(color, count)
  }

  #(id, sets)
}
