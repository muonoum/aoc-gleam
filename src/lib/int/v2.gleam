import gleam/dict.{type Dict}
import gleam/int.{absolute_value as abs}
import gleam/list
import gleam/result

pub const cardinals = [V2(1, 0), V2(0, -1), V2(0, 1), V2(-1, 0)]

pub const intercardinals = [
  V2(-1, -1),
  V2(1, -1),
  V2(1, 1),
  V2(-1, 1),
]

pub const directions = [
  V2(-1, -1),
  V2(0, -1),
  V2(1, -1),
  V2(-1, 0),
  V2(1, 0),
  V2(-1, 1),
  V2(0, 1),
  V2(1, 1),
]

pub type V2 {
  V2(x: Int, y: Int)
}

pub fn add(a: V2, b: V2) -> V2 {
  V2(a.x + b.x, a.y + b.y)
}

pub fn subtract(a: V2, b: V2) -> V2 {
  add(a, invert(b))
}

pub fn invert(v: V2) -> V2 {
  V2(-v.x, -v.y)
}

pub fn invert_x(v: V2) -> V2 {
  V2(-v.x, v.y)
}

pub fn invert_y(v: V2) -> V2 {
  V2(v.x, -v.y)
}

pub fn grid(rows: List(List(String))) -> List(#(V2, String)) {
  list.flatten({
    use row, y <- list.index_map(rows)
    use element, x <- list.index_map(row)
    #(V2(x, y), element)
  })
}

pub fn neighbors(
  position: V2,
  grid: Dict(V2, a),
  directions: List(V2),
) -> List(#(V2, a)) {
  use direction <- list.filter_map(directions)
  let position = add(position, direction)
  use neighbor <- result.try(dict.get(grid, position))
  Ok(#(position, neighbor))
}

pub fn area(points: List(V2)) -> Int {
  let base =
    int.sum({
      use #(current, next) <- list.map(list.window_by_2(points))
      current.x * next.y - current.y * next.x
    })

  abs(base) / 2
}
