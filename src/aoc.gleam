import aoc/day1
import aoc/day2
import aoc/day3
import aoc/day4
import aoc/day5
import aoc/day6
import aoc/day7
import aoc/day8
import aoc/day9
import gleam/bool
import gleam/dict
import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/task
import gleam/string
import simplifile

pub type Day {
  Day(Int, Int, Int)
}

pub fn days() {
  dict.from_list([
    #(1, #(day1.part1, day1.part2, "data/day1.txt")),
    #(2, #(day2.part1, day2.part2, "data/day2.txt")),
    #(3, #(day3.part1, day3.part2, "data/day3.txt")),
    #(4, #(day4.part1, day4.part2, "data/day4.txt")),
    #(5, #(day5.part1, day5.part2, "data/day5.txt")),
    #(6, #(day6.part1, day6.part2, "data/day6.txt")),
    #(7, #(day7.part1, day7.part2, "data/day7.txt")),
    #(8, #(day8.part1, day8.part2, "data/day8.txt")),
    #(9, #(day9.part1, day9.part2, "data/day9.txt")),
  ])
}

pub fn main() {
  let days = days()
  let _answers = answers()

  case erlang.start_arguments() {
    [day] -> {
      let assert Ok(day) = int.parse(day)
      let assert Ok(#(part1, part2, input)) = dict.get(days, day)
      let assert Ok(input) = simplifile.read(input)
      [io.debug(Day(day, part1(input), part2(input)))]
    }

    [] -> {
      dict.values({
        use day, #(part1, part2, input) <- dict.map_values(days)
        let assert Ok(input) = simplifile.read(input)
        use <- task.async
        Day(day, part1(input), part2(input))
      })
      |> list.map(task.await_forever)
      |> list.sort(day_order)
      |> list.map(io.debug)
    }

    _ -> panic
  }
}

pub fn answers() {
  dict.from_list({
    let assert Ok(data) = simplifile.read("data/answers.txt")
    use line <- list.filter_map(string.split(data, "\n"))
    use <- bool.guard(line == "", Error(Nil))

    let assert [day, part1, part2] =
      string.split(line, ",")
      |> list.filter_map(int.parse)

    Ok(#(day, #(part1, part2)))
  })
}

pub fn day_order(a, b) {
  case a, b {
    Day(a, _, _), Day(b, _, _) -> int.compare(a, b)
  }
}

pub fn noop(_) {
  -1
}
