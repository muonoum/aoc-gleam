import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/pair
import gleam/regexp

pub fn part1(input: String) -> Int {
  let assert Ok(muls) =
    regexp.compile(
      "mul\\((?<a>\\d+),(?<b>\\d+)\\)",
      regexp.Options(case_insensitive: False, multi_line: False),
    )

  int.sum({
    use regexp.Match(_, subs) <- list.map(regexp.scan(muls, parse(input)))
    let assert [Some(a), Some(b)] = subs
    let assert Ok(a) = int.parse(a)
    let assert Ok(b) = int.parse(b)
    a * b
  })
}

pub fn part2(input: String) -> Int {
  let assert Ok(muls) =
    regexp.compile(
      "mul\\((?<a>\\d+),(?<b>\\d+)\\)|don't\\(\\)|do\\(\\)",
      regexp.Options(case_insensitive: False, multi_line: False),
    )

  pair.first({
    use #(sum, enabled), regexp.Match(match, subs) <- list.fold(
      regexp.scan(muls, parse(input)),
      #(0, True),
    )

    case match, enabled {
      "do()", _ -> #(sum, True)
      "don't()", _ -> #(sum, False)
      _mul, False -> #(sum, enabled)
      _mul, True -> {
        let assert [Some(a), Some(b)] = subs
        let assert Ok(a) = int.parse(a)
        let assert Ok(b) = int.parse(b)
        #(a * b + sum, enabled)
      }
    }
  })
}

pub fn parse(input: String) {
  input
}
