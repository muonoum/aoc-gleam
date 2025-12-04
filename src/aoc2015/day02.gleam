import gleam/int
import gleam/list
import gleam/string
import lib/read

pub fn part1(input: String) -> Int {
  int.sum({
    use #(l, w, h) <- list.map(parse(input))
    let assert [a, b, c] as sides = [l * w, w * h, h * l]
    let assert Ok(slack) = list.reduce(sides, int.min)
    2 * a + 2 * b + 2 * c + slack
  })
}

pub fn part2(input: String) -> Int {
  int.sum({
    use #(l, w, h) <- list.map(parse(input))

    let ribbon = {
      let assert [a, b, ..] = list.sort([l, w, h], int.compare)
      a + a + b + b
    }

    l * w * h + ribbon
  })
}

fn parse(input: String) -> List(#(Int, Int, Int)) {
  use line <- list.map(read.lines(input))

  let assert [l, w, h] =
    string.split(line, "x")
    |> list.filter_map(int.parse)

  #(l, w, h)
}
