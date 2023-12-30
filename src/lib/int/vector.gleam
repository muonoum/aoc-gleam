import gleam/dict.{type Dict}
import gleam/list
import gleam/result

pub const directions = [V2(1, 0), V2(0, -1), V2(0, 1), V2(-1, 0)]

pub type V2 {
  V2(x: Int, y: Int)
}

pub type V3 {
  V3(x: Int, y: Int, z: Int)
}

pub fn add2(a: V2, b: V2) -> V2 {
  V2(a.x + b.x, a.y + b.y)
}

pub fn subtract2(a: V2, b: V2) -> V2 {
  add2(a, invert2(b))
}

pub fn add3(a: V3, b: V3) -> V3 {
  V3(a.x + b.x, a.y + b.y, a.z + b.z)
}

pub fn invert2(v: V2) -> V2 {
  V2(-v.x, -v.y)
}

pub fn grid(rows: List(List(String))) {
  list.flatten({
    use row, y <- list.index_map(rows)
    use element, x <- list.index_map(row)
    #(V2(x, y), element)
  })
}

pub fn neighbors(position: V2, grid: Dict(V2, a)) {
  use direction <- list.filter_map(directions)
  let position = add2(position, direction)
  use neighbor <- result.try(dict.get(grid, position))
  Ok(#(position, neighbor))
}
