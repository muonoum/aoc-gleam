import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/set
import gleam/yielder
import lib/read

pub fn part1(input: String) -> Int {
  list.fold(parse(input), 0, int.add)
}

pub fn part2(input: String) -> Int {
  let changes =
    parse(input)
    |> yielder.from_list
    |> yielder.cycle

  pair.first({
    use #(freq, seen), change <- yielder.fold_until(changes, #(0, set.new()))
    let freq = freq + change
    use <- bool.guard(set.contains(seen, freq), list.Stop(#(freq, seen)))
    list.Continue(#(freq, set.insert(seen, freq)))
  })
}

pub fn parse(input: String) {
  list.filter_map(read.lines(input), int.parse)
}
