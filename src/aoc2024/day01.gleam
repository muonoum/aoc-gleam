import gleam/bool
import gleam/int
import gleam/list
import lib/read

pub fn part1(input: String) -> Int {
  int.sum({
    let #(a, b) = parse(input)
    let a = list.sort(a, int.compare)
    let b = list.sort(b, int.compare)
    use #(a, b) <- list.map(list.zip(a, b))
    use <- bool.guard(a > b, a - b)
    use <- bool.guard(a < b, b - a)
    0
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    let #(a, b) = parse(input)
    use a <- list.map(a)

    let score = {
      use r, b <- list.fold(b, 0)
      use <- bool.guard(a == b, r + 1)
      r
    }

    a * score
  })
}

pub fn parse(input: String) -> #(List(Int), List(Int)) {
  list.unzip({
    use line <- list.map(read.lines(input))
    let assert [a, b] = read.integers(line, " ")
    #(a, b)
  })
}
