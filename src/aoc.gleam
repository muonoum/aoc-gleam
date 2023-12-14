import aoc/day1
import aoc/day2
import aoc/day3
import aoc/day4
import aoc/day5
import aoc/day6
import aoc/day7
import aoc/day8
import aoc/day9
import aoc/day14
import gleam/dict
import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/task
import gleam/string
import simplifile

@external(erlang, "timer", "tc")
fn time(fun: fn() -> a) -> #(Int, a)

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
    #(14, #(day14.part1, day14.part2, "data/day14.txt")),
  ])
}

pub fn main() {
  let days = days()

  case erlang.start_arguments() {
    [day] -> {
      let assert Ok(day) = int.parse(day)
      let assert Ok(#(part1, part2, input)) = dict.get(days, day)
      [io.println(run_day(day, part1, part2, input))]
    }

    [] -> {
      dict.values({
        use day, #(part1, part2, input) <- dict.map_values(days)
        use <- task.async
        run_day(day, part1, part2, input)
      })
      |> list.map(task.await_forever)
      |> list.map(io.println)
    }

    _ -> panic
  }
}

pub fn noop(_) {
  -1
}

pub fn format_day(day) {
  string.pad_left(int.to_string(day), 2, "0")
}

pub fn format_time(time) {
  "(" <> int.to_string(time / 1000) <> "ms)"
}

pub fn run_day(day, part1, part2, input) {
  let assert Ok(input) = simplifile.read(input)
  let #(time1, value1) = time(fn() { part1(input) })
  let #(time2, value2) = time(fn() { part2(input) })

  let parts = [
    format_day(day),
    int.to_string(value1),
    format_time(time1),
    int.to_string(value2),
    format_time(time2),
  ]

  string.join(parts, " ")
}
