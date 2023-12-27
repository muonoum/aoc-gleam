import gleam/int
import gleam/list
import lib/read

pub fn part1(input: String) -> Int {
  list.length({
    use #(a, b) <- list.filter(
      parse(input)
      |> list.window_by_2,
    )
    b > a
  })
}

pub fn part2(input: String) -> Int {
  list.length({
    use window <- list.filter(
      parse(input)
      |> list.window(3)
      |> list.window_by_2,
    )
    let assert #(a, b) = window
    int.sum(b) > int.sum(a)
  })
}

fn parse(input: String) -> List(Int) {
  read.lines(input)
  |> list.filter_map(int.parse)
}
