import gleam/bool
import gleam/int
import gleam/list
import gleam/string

fn is_possible(color, count) {
  case color, count {
    "red", count if count > 12 -> Error(Nil)
    "green", count if count > 13 -> Error(Nil)
    "blue", count if count > 14 -> Error(Nil)
    _other, _wise -> Ok(count)
  }
}

pub fn part1(input: String) {
  int.sum({
    use line <- list.filter_map(string.split(input, on: "\n"))
    use <- bool.guard(when: line == "", return: Error(Nil))

    let assert [id, sets] = string.split(line, on: ":")
    let assert [_, id] = string.split(id, on: " ")
    let assert Ok(id) = int.parse(id)

    let sets = {
      use set <- list.try_map(string.split(sets, on: ";"))
      use set <- list.try_map(string.split(set, on: ","))
      let assert [count, color] =
        string.trim(set)
        |> string.split(on: " ")
      let assert Ok(count) = int.parse(count)
      is_possible(color, count)
    }

    use <- bool.guard(when: sets == Error(Nil), return: Error(Nil))
    Ok(id)
  })
}
