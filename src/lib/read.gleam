import gleam/int
import gleam/list
import gleam/string
import lib
import lib/int/v2.{type V2, V2}

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
  string.to_graphemes(string)
  |> list.filter_map(int.base_parse(_, 16))
}

pub fn grid(input: String) -> List(#(V2, String)) {
  list.flatten({
    use line, row <- list.index_map(lines(input))
    use grapheme, column <- list.index_map(string.to_graphemes(line))
    #(V2(column, row), grapheme)
  })
}
