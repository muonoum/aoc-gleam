import gleam/result
import gleam_community/maths/elementary.{square_root}

pub const directions = [
  V2(1.0, 0.0),
  V2(0.0, -1.0),
  V2(0.0, 1.0),
  V2(-1.0, 0.0),
]

pub type V2 {
  V2(x: Float, y: Float)
}

pub type V3 {
  V3(x: Float, y: Float, z: Float)
}

pub fn add2(a: V2, b: V2) -> V2 {
  V2(a.x +. b.x, a.y +. b.y)
}

pub fn add3(a: V3, b: V3) -> V3 {
  V3(a.x +. b.x, a.y +. b.y, a.z +. b.z)
}

pub fn invert2(v: V2) -> V2 {
  V2(v.x *. -1.0, v.y *. -1.0)
}

pub fn normalize(v: V2) {
  use length <- result.try(
    square_root(v.x *. v.x +. v.y *. v.y)
    |> result.nil_error,
  )

  V2(v.x /. length, v.y /. length)
  |> Ok
}
