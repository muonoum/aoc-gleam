import gleam/result
import gleam_community/maths

pub const directions = [
  V2(1.0, 0.0),
  V2(0.0, -1.0),
  V2(0.0, 1.0),
  V2(-1.0, 0.0),
]

pub type V2 {
  V2(x: Float, y: Float)
}

pub fn add(a: V2, b: V2) -> V2 {
  V2(a.x +. b.x, a.y +. b.y)
}

pub fn invert(v: V2) -> V2 {
  V2(v.x *. -1.0, v.y *. -1.0)
}

pub fn normalize(v: V2) -> Result(V2, Nil) {
  use length <- result.try(
    maths.nth_root(v.x *. v.x +. v.y *. v.y, 2)
    |> result.replace_error(Nil),
  )

  Ok(V2(v.x /. length, v.y /. length))
}
