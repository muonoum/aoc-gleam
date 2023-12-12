import gleam/int
import gleam/list
import gleam/string

pub fn part1(input: String) -> Int {
  int.product({
    use #(time, record) <- list.map(parse(input))

    list.length({
      use held <- list.filter_map(list.range(0, time))

      case held * { time - held } {
        distance if distance > record -> Ok(distance)
        _ -> Error(Nil)
      }
    })
  })
}

pub fn part2(_input: String) -> Int {
  -1
}

fn parse(input) {
  let lines = string.split(input, "\n")

  let assert #(times, records) = {
    use #(times, records), line <- list.fold(lines, #([], []))

    case line {
      "Time:" <> v -> #(numbers(v), records)
      "Distance:" <> v -> #(times, numbers(v))
      _ -> #(times, records)
    }
  }

  list.zip(times, records)
}

fn numbers(v) {
  string.split(v, " ")
  |> list.map(string.trim)
  |> list.filter(fn(v) { v != "" })
  |> list.filter_map(int.parse)
}
