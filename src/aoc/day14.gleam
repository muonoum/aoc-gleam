import gleam/bool
import gleam/int
import gleam/list
import gleam/order
import gleam/string

pub fn part1(input: String) -> Int {
  let columns = parse(input)

  int.sum({
    use column <- list.map(columns)

    int.sum({
      string.join(column, "")
      |> string.split("#")
      |> list.intersperse("#")
      |> list.map(string.split(_, ""))
      |> list.flat_map(tilt)
      |> list.reverse
      |> list.index_map(load)
    })
  })
}

pub fn part2(_input: String) -> Int {
  -1
}

fn tilt(column: List(String)) -> List(String) {
  use spot, _ <- list.sort(column)
  use <- bool.guard(spot == "O", order.Lt)
  order.Gt
}

fn load(index: Int, spot: String) -> Int {
  use <- bool.guard(spot != "O", 0)
  index + 1
}

pub fn parse(input) {
  list.transpose({
    use line <- list.filter_map(string.split(input, "\n"))
    use <- bool.guard(line == "", Error(Nil))
    Ok(string.split(line, ""))
  })
}
