import gleam/bool
import gleam/int.{absolute_value as abs}
import gleam/list
import lib/read

pub fn part1(input: String) -> Int {
  use count, report <- list.fold(parse(input), 0)
  let diff = {
    use #(current, last) <- list.map(list.window_by_2(report))
    last - current
  }

  let increasing = list.all(diff, fn(v) { v > 0 })
  let decreasing = list.all(diff, fn(v) { v < 0 })
  let safe = list.all(diff, fn(v) { abs(v) >= 1 && abs(v) <= 3 })
  use <- bool.guard(safe && { increasing || decreasing }, count + 1)
  count
}

pub fn part2(input: String) -> Int {
  use count, report <- list.fold(parse(input), 0)

  let result = {
    use result, #(a, b) <- list.fold_until(
      list.window_by_2(report),
      Ok(#(0, 1)),
    )

    case result {
      Error(err) -> list.Stop(Error(err))

      Ok(#(direction, dampen)) ->
        case a - b {
          diff if diff < -3 && dampen > 0 ->
            list.Continue(Ok(#(direction, dampen - 1)))
          diff if diff < -3 -> list.Stop(Error(Nil))

          diff if diff > 3 && dampen > 0 ->
            list.Continue(Ok(#(direction, dampen - 1)))
          diff if diff > 3 -> list.Stop(Error(Nil))

          diff if diff > 0 && direction < 0 && dampen > 0 ->
            list.Continue(Ok(#(direction, dampen - 1)))
          diff if diff > 0 && direction < 0 -> list.Stop(Error(Nil))

          diff if diff < 0 && direction > 0 && dampen > 0 ->
            list.Continue(Ok(#(direction, dampen - 1)))
          diff if diff < 0 && direction > 0 -> list.Stop(Error(Nil))

          diff if diff < 0 -> list.Continue(Ok(#(-1, dampen)))
          diff if diff > 0 -> list.Continue(Ok(#(1, dampen)))
          _diff if dampen > 0 -> list.Continue(Ok(#(direction, dampen - 1)))
          _diff -> list.Stop(Error(Nil))
        }
    }
  }

  case result {
    Error(_) -> count
    Ok(_) -> count + 1
  }
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))
  read.integers(line, " ")
}
