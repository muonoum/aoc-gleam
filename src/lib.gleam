import gleam/bool
import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/string

pub fn power(base, exponent) {
  power_loop(base, exponent, 1)
}

fn power_loop(base, exponent, result) {
  let result = {
    use <- bool.guard(int.bitwise_and(exponent, 1) == 0, result)
    result * base
  }

  let exponent = int.bitwise_shift_right(exponent, 1)
  use <- bool.guard(exponent == 0, result)
  power_loop(base * base, exponent, result)
}

pub fn digits(v: Int, base: Int) -> Result(List(Int), Nil) {
  case base < 2 {
    True -> Error(Nil)
    False -> Ok(digits_loop(v, base, []))
  }
}

fn digits_loop(v: Int, base: Int, acc: List(Int)) -> List(Int) {
  case int.absolute_value(v) < base {
    True -> [v, ..acc]
    False -> digits_loop(v / base, base, [v % base, ..acc])
  }
}

pub fn undigits(numbers: List(Int), base: Int) -> Result(Int, Nil) {
  case base < 2 {
    True -> Error(Nil)
    False -> undigits_loop(numbers, base, 0)
  }
}

fn undigits_loop(numbers: List(Int), base: Int, acc: Int) -> Result(Int, Nil) {
  case numbers {
    [] -> Ok(acc)
    [digit, ..] if digit >= base -> Error(Nil)
    [digit, ..rest] -> undigits_loop(rest, base, acc * base + digit)
  }
}

pub fn clusters(v: List(v)) -> List(Int) {
  list.group(v, function.identity)
  |> dict.values()
  |> list.map(list.length)
}

pub fn greater_than(v: Int, n: Int) -> Bool {
  v > n
}

pub fn non_zero_integer(integer: Int) -> Bool {
  integer != 0
}

pub fn non_empty_string(string: String) -> Bool {
  string != ""
}

pub fn return(wrap: fn(a) -> b, body: fn() -> a) -> b {
  wrap(body())
}

pub fn remove(string: String, remove: String) -> String {
  use string, grapheme <- list.fold(string.to_graphemes(remove), string)
  string.replace(string, grapheme, "")
}
