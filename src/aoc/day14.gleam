import gleam/bool
import gleam/int
import gleam/list
import gleam/order
import gleam/string

pub fn part1(input: String) -> Int {
  int.sum({
    use column <- list.map(
      parse(input)
      |> list.transpose,
    )

    int.sum({
      string.join(column, "")
      |> string.split("#")
      |> list.intersperse("#")
      |> list.flat_map(fn(column) {
        use spot, _ <- list.sort(string.split(column, ""))
        use <- bool.guard(spot == "O", order.Lt)
        order.Gt
      })
      |> list.reverse
      |> list.index_map(fn(spot, index) {
        use <- bool.guard(spot != "O", 0)
        index + 1
      })
    })
  })
}

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(input: String) -> List(List(String)) {
  use line <- list.filter_map(string.split(input, "\n"))
  use <- bool.guard(line == "", Error(Nil))
  Ok(string.split(line, ""))
}
