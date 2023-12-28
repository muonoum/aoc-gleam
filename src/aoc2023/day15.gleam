import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import gleam/string
import lib/read

pub type Operation {
  Add(label: String, hash: Int, length: Int)
  Remove(label: String, hash: Int)
}

pub fn part1(input: String) -> Int {
  read.fields(input, ",")
  |> list.map(hash)
  |> int.sum
}

pub fn part2(input: String) -> Int {
  let boxes = {
    let ops = parse_ops(input)
    use boxes, op <- list.fold(ops, dict.new())

    case op {
      Add(label, hash, length) -> {
        use box <- dict.update(boxes, hash)
        case box {
          option.None -> [#(label, length)]
          option.Some(box) -> list.key_set(box, label, length)
        }
      }

      Remove(label, hash) -> {
        use box <- dict.update(boxes, hash)
        case box {
          option.None -> []
          option.Some(box) ->
            list.key_pop(box, label)
            |> result.map(pair.second)
            |> result.unwrap(box)
        }
      }
    }
  }

  dict.values({
    use hash, box <- dict.map_values(boxes)
    use #(_label, length), index <- list.index_map(box)
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

fn parse(input: String) -> List(String) {
  string.trim(input)
  |> string.split(",")
}

fn parse_ops(input: String) -> List(Operation) {
  use op <- list.filter_map(parse(input))
  use <- result.lazy_or(parse_add(op))
  parse_remove(op)
}

fn parse_add(op: String) -> Result(Operation, Nil) {
  case string.split(op, "=") {
    [label, length] -> {
      let assert Ok(length) = int.parse(length)
      Ok(Add(label, hash(label), length))
    }
    _ -> Error(Nil)
  }
}

fn parse_remove(op: String) -> Result(Operation, Nil) {
  case string.split(op, "-") {
    [label, _] -> Ok(Remove(label, hash(label)))
    _ -> Error(Nil)
  }
}
