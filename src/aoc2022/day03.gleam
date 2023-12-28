import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/pair
import gleam/set.{type Set}
import gleam/string
import lib/read

pub type Compartment =
  Set(#(String, Int))

pub fn part1(input: String) -> Int {
  int.sum({
    use #(a, b) <- list.flat_map(parse(input))
    set.intersection(a, b)
    |> set.to_list
    |> list.map(pair.second)
  })
}

pub fn part2(input: String) -> Int {
  let sacks = {
    use #(a, b) <- list.map(parse(input))
    set.union(a, b)
  }

  int.sum({
    use group <- list.flat_map(list.sized_chunk(sacks, 3))
    let assert [a, b, c] = group
    set.intersection(a, set.intersection(b, c))
    |> set.to_list
    |> list.map(pair.second)
  })
}

pub fn parse(input: String) -> List(#(Compartment, Compartment)) {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  let lookup =
    dict.from_list({
      use grapheme, index <- list.index_map(string.to_graphemes(letters))
      #(grapheme, index + 1)
    })

  use line <- list.map(read.lines(input))
  let length = string.length(line)
  let half = length / 2
  let first = string.slice(line, 0, half)
  let second = string.slice(line, half, length)
  #(parse_compartment(first, lookup), parse_compartment(second, lookup))
}

fn parse_compartment(
  content: String,
  lookup: Dict(String, Int),
) -> Set(#(String, Int)) {
  set.from_list({
    use grapheme <- list.map(string.to_graphemes(content))
    let assert Ok(priority) = dict.get(lookup, grapheme)
    #(grapheme, priority)
  })
}
