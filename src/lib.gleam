import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string

pub type Vector {
  Vector(x: Int, y: Int)
}

pub const directions = [
  Vector(1, 0),
  Vector(0, -1),
  Vector(0, 1),
  Vector(-1, 0),
]

pub fn neighbors(position: Vector, grid: Dict(Vector, a)) {
  use direction <- list.filter_map(directions)
  let position = add_vectors(position, direction)
  use neighbor <- result.try(dict.get(grid, position))
  Ok(#(position, neighbor))
}

pub fn add_vectors(a: Vector, b: Vector) -> Vector {
  Vector(a.x + b.x, a.y + b.y)
}

pub fn invert_vector(v: Vector) {
  Vector(-v.x, -v.y)
}

pub fn lines(input: String) -> List(String) {
  use line <- list.map({
    use line <- list.filter(string.split(input, "\n"))
    line != ""
  })

  line
}

pub fn grid(rows: List(List(String))) {
  list.flatten({
    use row, y <- list.index_map(rows)
    use element, x <- list.index_map(row)
    #(Vector(x, y), element)
  })
}

pub fn parse_grid(input: String) -> List(#(Vector, String)) {
  list.flatten({
    use line, row <- list.index_map(lines(input))
    use grapheme, column <- list.index_map(string.to_graphemes(line))
    #(Vector(column, row), grapheme)
  })
}

pub fn return(a: fn(a) -> b, body: fn() -> a) -> b {
  a(body())
}
