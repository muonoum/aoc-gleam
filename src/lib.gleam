import gleam/dict
import gleam/function
import gleam/list
import gleam/string

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
