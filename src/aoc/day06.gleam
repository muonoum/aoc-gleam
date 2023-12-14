import gleam/int
import gleam/list
import gleam/string

pub fn part1(input: String) -> Int {
  int.product({
    let #(times, records) = parse(input)

    use #(time, record) <- list.map({
      use #(time, record) <- list.map(list.zip(times, records))
      let assert Ok(time) = int.parse(time)
      let assert Ok(record) = int.parse(record)
      #(time, record)
    })

    list.length({
      use held <- list.filter_map(list.range(0, time))

      case held * { time - held } {
        distance if distance > record -> Ok(distance)
        _ -> Error(Nil)
      }
    })
  })
}

pub fn part2(input: String) -> Int {
  let #(times, records) = parse(input)
  let assert Ok(time) = int.parse(string.join(times, ""))
  let assert Ok(record) = int.parse(string.join(records, ""))

  list.length({
    use held <- list.filter_map(list.range(0, time))

    case held * { time - held } {
      distance if distance > record -> Ok(distance)
      _ -> Error(Nil)
    }
  })
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

  #(times, records)
}

fn numbers(v) {
  string.split(v, " ")
  |> list.map(string.trim)
  |> list.filter(fn(v) { v != "" })
}
