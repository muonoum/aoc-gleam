import gleam/bool
import gleam/dict.{type Dict}
import gleam/function.{identity}
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import lib
import lib/read

pub fn part1(input: String) -> Int {
  let #(rules, updates) = parse(input)

  int.sum({
    use #(update, dict) <- list.filter_map(updates)
    use <- bool.guard(!valid(dict, rules), Error(Nil))
    let assert [v, ..] = list.drop(update, list.length(update) / 2)
    Ok(v)
  })
}

fn valid(dict: Dict(Int, Int), rules: List(#(Int, Int))) -> Bool {
  use <- lib.return(list.all(_, identity))
  use #(before, after) <- list.filter_map(rules)
  use before <- result.try(dict.get(dict, before))
  use after <- result.try(dict.get(dict, after))
  Ok(before < after)
}

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(
  input: String,
) -> #(List(#(Int, Int)), List(#(List(Int), Dict(Int, Int)))) {
  let assert Ok(#(rules, updates)) = string.split_once(input, "\n\n")

  let rules = {
    use line <- list.map(read.lines(rules))
    let assert [before, after] = read.integers(line, "|")
    #(before, after)
  }

  let updates = {
    use line <- list.map(read.lines(updates))
    let update = read.integers(line, ",")
    let dict = dict.from_list(list.index_map(update, pair.new))
    #(update, dict)
  }

  #(rules, updates)
}
