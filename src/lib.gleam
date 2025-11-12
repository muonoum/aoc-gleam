import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/string

pub fn digits(x: Int, base: Int) -> Result(List(Int), Nil) {
  case base < 2 {
    True -> Error(Nil)
    False -> Ok(digits_loop(x, base, []))
  }
}

fn digits_loop(x: Int, base: Int, acc: List(Int)) -> List(Int) {
  case int.absolute_value(x) < base {
    True -> [x, ..acc]
    False -> digits_loop(x / base, base, [x % base, ..acc])
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

pub fn clusters(v) {
  list.group(v, function.identity)
  |> dict.values()
  |> list.map(list.length)
}

pub fn gt(v, n) {
  v > n
}

pub fn non_zero(integer: Int) -> Bool {
  integer != 0
}

pub fn non_empty_string(string: String) -> Bool {
  string != ""
}

pub fn return(a: fn(a) -> b, body: fn() -> a) -> b {
  a(body())
}

pub fn remove(string: String, set: String) -> String {
  use string, grapheme <- list.fold(string.to_graphemes(set), string)
  string.replace(string, grapheme, "")
}
