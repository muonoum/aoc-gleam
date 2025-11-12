import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/set
import lib
import lib/int/v2.{type V2, V2}
import lib/read

pub fn part1(input: String) -> Int {
  let wires = parse(input)
  let assert [set1, set2] =
    list.map(wires, list.map(_, pair.first))
    |> list.map(set.from_list)

  let crossings =
    set.intersection(set1, set2)
    |> set.to_list
  let distances = {
    use V2(x, y) <- list.map(crossings)
    int.absolute_value(x) + int.absolute_value(y)
  }

  let assert Ok(distance) =
    list.sort(distances, int.compare)
    |> list.first
  distance
}

pub fn part2(input: String) -> Int {
  let assert [wire1, wire2] as wires = parse(input)
  let locations1 = dict.from_list(wire1)
  let locations2 = dict.from_list(wire2)
  let assert [set1, set2] =
    list.map(wires, list.map(_, pair.first))
    |> list.map(set.from_list)

  let crossings = {
    use location <- list.map(
      set.intersection(set1, set2)
      |> set.to_list,
    )
    let assert Ok(a) = dict.get(locations1, location)
    let assert Ok(b) = dict.get(locations2, location)
    a + b
  }

  let assert Ok(best) =
    list.sort(crossings, int.compare)
    |> list.first

  best
}

fn trace(wires: List(List(#(V2, Int)))) {
  use moves <- list.map(wires)
  use <- lib.return(list.reverse)
  use path, #(move, count) <- list.fold(moves, [])
  use path, _ <- list.fold(list.range(1, count), path)
  case path {
    [] -> [#(move, 1)]
    [#(last, count), ..] -> [#(v2.add(last, move), count + 1), ..path]
  }
}

pub fn parse(input: String) {
  use <- lib.return(trace)
  use line <- list.map(read.lines(input))
  use move <- list.map(read.fields(line, ","))
  parse_move(move)
}

fn parse_move(move) {
  case move {
    "L" <> moves -> {
      let assert Ok(number) = int.parse(moves)
      #(V2(-1, 0), number)
    }
    "R" <> moves -> {
      let assert Ok(number) = int.parse(moves)
      #(V2(1, 0), number)
    }
    "U" <> moves -> {
      let assert Ok(number) = int.parse(moves)
      #(V2(0, -1), number)
    }
    "D" <> moves -> {
      let assert Ok(number) = int.parse(moves)
      #(V2(0, 1), number)
    }
    _else -> panic
  }
}
