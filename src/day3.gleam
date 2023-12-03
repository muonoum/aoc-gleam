import gleam/int
import gleam/list
import gleam/string

@external(erlang, "day3_ext", "match")
fn match(string: String, pattern: String) -> List(List(#(Int, Int)))

pub type Entity {
  Number(start: Int, end: Int, number: Int)
  Part(index: Int, symbol: String)
}

fn is_number(entity: Entity) -> Bool {
  case entity {
    Number(..) -> True
    _ -> False
  }
}

fn is_gear(entity: Entity) -> Bool {
  case entity {
    Part(symbol: "*", ..) -> True
    _ -> False
  }
}

pub fn part1(input: String) {
  parse(input)
  |> check1
  |> list.flatten
  |> int.sum
}

pub fn part2(input: String) {
  parse(input)
  |> check2
  |> list.flatten
  |> int.sum
}

fn parse(input: String) -> List(List(Entity)) {
  use line <- list.map(
    string.split(input, on: "\n")
    |> list.filter(fn(line) { line != "" }),
  )

  use match <- list.map(match(line, "(?<N>\\d+)(?=[^\\d]|$)|(?<P>[^\\d.])"))

  case match {
    [#(start, length), #(-1, _)] if start >= 0 -> {
      let assert Ok(number) =
        string.slice(line, start, length)
        |> int.parse
      Number(start: start, end: start + length - 1, number: number)
    }

    [#(-1, _), #(start, length)] if start >= 0 ->
      string.slice(line, start, length)
      |> Part(index: start, symbol: _)

    _ -> panic
  }
}

fn check1(lines: List(List(Entity))) {
  use #(first, second) <- list.map(list.window_by_2(lines))

  let #(first_numbers, parts1) = list.partition(first, is_number)
  let #(second_numbers, parts2) = list.partition(second, is_number)

  let first_numbers = {
    use number <- list.filter_map(first_numbers)
    let assert Number(start, end, part_number) = number
    let curr =
      list.any(parts1, fn(part) {
        let assert Part(index, _) = part
        index == start - 1 || index == end + 1
      })
    let next =
      list.any(parts2, fn(part) {
        let assert Part(index, _) = part
        index >= start - 1 && index <= end + 1
      })

    case curr || next {
      True -> Ok(part_number)
      False -> Error(Nil)
    }
  }

  let second_numbers = {
    use number <- list.filter_map(second_numbers)
    let assert Number(start, end, part_number) = number
    let prev =
      list.any(parts1, fn(part) {
        let assert Part(index, _) = part
        index >= start - 1 && index <= end + 1
      })

    case prev {
      True -> Ok(part_number)
      False -> Error(Nil)
    }
  }

  list.flatten([first_numbers, second_numbers])
}

fn check2(lines: List(List(Entity))) -> List(List(Int)) {
  use line <- list.map(list.window(lines, 3))
  let assert [prev, curr, next] = line

  let #(prev, _) = list.partition(prev, is_number)
  let #(curr, parts) = list.partition(curr, is_number)
  let #(next, _) = list.partition(next, is_number)

  use gear <- list.filter_map(list.filter(parts, is_gear))
  let assert Part(index, "*") = gear

  let prev =
    list.filter_map(prev, fn(num) {
      let assert Number(start, end, part_number) = num
      case index >= start - 1 && index <= end + 1 {
        True -> Ok(part_number)
        False -> Error(Nil)
      }
    })
  let curr =
    list.filter_map(curr, fn(num) {
      let assert Number(start, end, part_number) = num
      case index == start - 1 || index == end + 1 {
        True -> Ok(part_number)
        False -> Error(Nil)
      }
    })
  let next =
    list.filter_map(next, fn(num) {
      let assert Number(start, end, part_number) = num
      case index >= start - 1 && index <= end + 1 {
        True -> Ok(part_number)
        False -> Error(Nil)
      }
    })

  case list.flatten([prev, curr, next]) {
    [a, b] -> Ok(a * b)
    _ -> Error(Nil)
  }
}
