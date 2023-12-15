import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/pair
import gleam/result
import gleam/string

pub type Operation {
  Add(label: String, hash: Int, length: Int)
  Remove(label: String, hash: Int)
}

pub fn part1(input: String) -> Int {
  string.trim(input)
  |> string.split(",")
  |> list.map(hash)
  |> int.sum
}

pub fn part2(input: String) -> Int {
  let boxes = {
    use boxes, operation <- list.fold(parse(input), dict.new())

    case operation {
      Add(label, hash, length) -> {
        use box <- dict.update(boxes, hash)

        case box {
          None -> [#(label, length)]
          Some(box) -> list.key_set(box, label, length)
        }
      }

      Remove(label, hash) -> {
        use box <- dict.update(boxes, hash)

        case box {
          None -> []

          Some(box) ->
            list.key_pop(box, label)
            |> result.map(pair.second)
            |> result.unwrap(box)
        }
      }
    }
  }

  dict.values({
    use hash, box <- dict.map_values(boxes)
    use index, #(_label, length) <- list.index_map(box)
    { 1 + hash } * { 1 + index } * length
  })
  |> list.flatten
  |> int.sum
}

fn hash(string: String) -> Int {
  use current, grapheme <- list.fold(string.to_graphemes(string), 0)
  let assert [codepoint] = string.to_utf_codepoints(grapheme)
  let code = string.utf_codepoint_to_int(codepoint)
  let assert Ok(current) = int.remainder({ current + code } * 17, 256)
  current
}

fn parse(input: String) {
  use operation <- list.filter_map(
    string.trim(input)
    |> string.split(","),
  )

  use <- result.lazy_or(parse_add(operation))
  parse_remove(operation)
}

fn parse_add(operation: String) -> Result(Operation, Nil) {
  case string.split(operation, "=") {
    [label, length] -> {
      let assert Ok(length) = int.parse(length)
      Ok(Add(label, hash(label), length))
    }
    _ -> Error(Nil)
  }
}

fn parse_remove(operation: String) -> Result(Operation, Nil) {
  case string.split(operation, "-") {
    [label, _] -> Ok(Remove(label, hash(label)))
    _ -> Error(Nil)
  }
}
