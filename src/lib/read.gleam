import gleam/int
import gleam/list
import gleam/string
import lib

pub fn lines(input: String) -> List(String) {
  use line <- list.map({
    use line <- list.filter(string.split(input, "\n"))
    line != ""
  })

  line
}

pub fn fields(string: String, separator: String) {
  string.split(string, separator)
  |> list.map(string.trim)
  |> list.filter(lib.non_empty_string)
}

pub fn integers(string: String, separator: String) {
  fields(string, separator)
  |> list.filter_map(int.parse)
}

pub fn hex(string: String) {
  use grapheme <- list.filter_map(string.to_graphemes(string))
  int.base_parse(grapheme, 16)
}

pub fn grid(input: String) -> List(List(String)) {
  use line <- list.map(lines(input))
  string.to_graphemes(line)
}
