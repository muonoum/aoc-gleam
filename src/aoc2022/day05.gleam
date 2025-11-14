import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import lib
import lib/read

pub type Token {
  Stack(List(String))
  Move(#(Int, Int, Int))
}

pub fn part1(input: String) -> Int {
  let stacks = {
    let #(stacks, moves) = parse(input)
    use stacks, #(quantity, from, to) <- list.fold(moves, stacks)
    let assert Ok(source) = dict.get(stacks, from)
    let assert Ok(destination) = dict.get(stacks, to)
    let #(crates, source) = list.split(source, quantity)
    let destination = list.fold(crates, destination, list.prepend)

    dict.insert(stacks, from, source)
    |> dict.insert(to, destination)
  }

  list.filter_map(dict.values(stacks), list.first)
  |> string.join("")
  |> echo

  -1
}

pub fn part2(input: String) -> Int {
  let stacks = {
    let #(stacks, moves) = parse(input)
    use stacks, #(quantity, from, to) <- list.fold(moves, stacks)
    let assert Ok(source) = dict.get(stacks, from)
    let assert Ok(destination) = dict.get(stacks, to)
    let #(crates, source) = list.split(source, quantity)
    let destination = list.append(crates, destination)

    dict.insert(stacks, from, source)
    |> dict.insert(to, destination)
  }

  list.filter_map(dict.values(stacks), list.first)
  |> string.join("")
  |> echo

  -1
}

pub fn parse(input: String) {
  let assert #(_, [_, moves, crates]) = {
    let state = #(parse_stack, [[]])
    use #(parser, buckets), line <- list.fold(string.split(input, "\n"), state)
    let assert [bucket, ..rest] = buckets

    case line {
      "" -> #(parse_move, [[], ..buckets])
      line -> #(parser, [[parser(line), ..bucket], ..rest])
    }
  }

  let stacks =
    list.transpose({
      use stack <- list.filter_map(list.reverse(crates))
      let assert Stack(stack) = stack
      let empty = list.filter(stack, lib.non_empty_string) == []
      use <- bool.guard(empty, Error(Nil))
      Ok(stack)
    })

  let stacks =
    dict.from_list({
      use stack, index <- list.index_map(stacks)

      let stack = {
        use crate <- list.filter_map(stack)
        use <- bool.guard(crate == "", Error(Nil))
        Ok(crate)
      }

      #(index + 1, stack)
    })

  let moves = {
    use move <- list.map(list.reverse(moves))
    let assert Move(#(quantity, from, to)) = move
    #(quantity, from, to)
  }

  #(stacks, moves)
}

fn parse_move(line: String) {
  let assert [number, start, end] =
    read.fields(line, " ")
    |> list.filter_map(int.parse)

  Move(#(number, start, end))
}

fn parse_stack(line: String) {
  Stack({
    use crate <- list.filter_map(
      string.to_graphemes(line)
      |> list.sized_chunk(4),
    )

    case crate {
      ["[", id, "]", " "] -> Ok(id)
      ["[", id, "]"] -> Ok(id)
      [_, _, _, _] -> Ok("")
      [_, _, _] -> Ok("")
      _ -> panic as string.inspect(crate)
    }
  })
}
