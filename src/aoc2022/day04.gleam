import gleam/list
import gleam/set
import lib/read

pub fn part1(input: String) -> Int {
  list.length({
    use #(a, b) <- list.filter(parse(input))
    let common = set.intersection(a, b)
    common == a || common == b
  })
}

pub fn part2(input: String) -> Int {
  list.length({
    use #(a, b) <- list.filter(parse(input))
    set.size(set.intersection(a, b)) != 0
  })
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))
  let assert [[a, b], [c, d]] =
    read.fields(line, ",")
    |> list.map(read.integers(_, "-"))
  let first = set.from_list(list.range(a, b))
  let second = set.from_list(list.range(c, d))
  #(first, second)
}
