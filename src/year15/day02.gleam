import gleam/bool
import gleam/int
import gleam/list
import gleam/string

pub fn part1(input: String) {
  int.sum({
    use #(l, w, h) <- list.map(parse(input))
    let assert [a, b, c] as sides = [l * w, w * h, h * l]
    let assert Ok(slack) = list.reduce(sides, int.min)

    let feet = 2 * a + 2 * b + 2 * c
    feet + slack
  })
}

pub fn part2(_input: String) {
  -1
}

fn parse(input: String) -> List(#(Int, Int, Int)) {
  use line <- list.filter_map(string.split(input, "\n"))
  use <- bool.guard(line == "", Error(Nil))

  let assert [l, w, h] =
    string.split(line, "x")
    |> list.filter_map(int.parse)

  Ok(#(l, w, h))
}
