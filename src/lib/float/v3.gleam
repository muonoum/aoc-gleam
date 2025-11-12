pub type V3 {
  V3(x: Float, y: Float, z: Float)
}

pub fn add(a: V3, b: V3) -> V3 {
  V3(a.x +. b.x, a.y +. b.y, a.z +. b.z)
}

pub fn subtract(a: V3, b: V3) -> V3 {
  add(a, invert(b))
}

pub fn invert(v: V3) -> V3 {
  V3(v.x *. -1.0, v.y *. -1.0, v.z *. -1.0)
}
