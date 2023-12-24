import gleam/list
import gleam/string

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
