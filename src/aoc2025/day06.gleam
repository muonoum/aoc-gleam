import gleam/int
import gleam/list
import gleam/string
import lib/read

type Operation =
  fn(List(Int)) -> Int

pub fn part1(input: String) -> Int {
  let assert [ops, ..rows] = list.reverse(read.lines(input))
  let #(ops, _widths) = list.unzip(parse_ops(ops, []))

  let columns =
    list.transpose({
      use row <- list.map(rows)
      use field <- list.map(read.fields(row, " "))
      string.to_graphemes(field) |> parse_number
    })

  int.sum({
    use op, numbers <- list.map2(ops, columns)
    op(numbers)
  })
}

pub fn part2(input: String) -> Int {
  let assert [ops, ..numbers] = list.reverse(read.lines(input))
  let #(ops, widths) = list.unzip(parse_ops(ops, []))

  let columns = {
    use row <- list.map(
      list.transpose({
        use row <- list.map(list.reverse(numbers))
        string.to_graphemes(row) |> parse_rows(widths, [])
      }),
    )

    list.transpose(row)
    |> list.map(parse_number)
  }

  int.sum({
    use op, numbers <- list.map2(ops, columns)
    op(numbers)
  })
}

fn parse_number(graphemes: List(String)) -> Int {
  string.join(graphemes, "") |> string.trim |> read.integer
}

fn parse_ops(
  string: String,
  ops: List(#(Operation, Int)),
) -> List(#(Operation, Int)) {
  case string, ops {
    "", [#(op, width), ..ops] -> list.reverse([#(op, width + 1), ..ops])

    " " <> rest, [#(op, width), ..ops] ->
      parse_ops(rest, [#(op, width + 1), ..ops])

    "*" <> rest, ops -> parse_ops(rest, [#(int.product, 0), ..ops])
    "+" <> rest, ops -> parse_ops(rest, [#(int.sum, 0), ..ops])
    _other, _wise -> panic
  }
}

fn parse_rows(
  graphemes: List(String),
  widths: List(Int),
  rows: List(List(String)),
) -> List(List(String)) {
  case widths {
    [] -> list.reverse(rows)

    [width, ..widths] ->
      [list.take(graphemes, width), ..rows]
      |> parse_rows(list.drop(graphemes, width + 1), widths, _)
  }
}
