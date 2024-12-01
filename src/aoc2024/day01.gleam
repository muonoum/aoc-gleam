import gleam/int
import gleam/list
import lib/read

pub fn part1(input: String) -> Int {
  int.sum({
    let #(a, b) = parse(input)
    let a = list.sort(a, int.compare)
    let b = list.sort(b, int.compare)

    use #(a, b) <- list.map(list.zip(a, b))

    case a, b {
      a, b if a > b -> a - b
      a, b if a < b -> b - a
      _other, _wise -> 0
    }
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    let #(a, b) = parse(input)
    use a <- list.map(a)

    let score = {
      use r, b <- list.fold(b, 0)

      case a == b {
        True -> r + 1
        False -> r
      }
    }

    a * score
  })
}

pub fn parse(input: String) {
  list.unzip({
    use line <- list.map(read.lines(input))
    let assert [a, b] = read.integers(line, " ")
    #(a, b)
  })
}
