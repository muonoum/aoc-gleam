pub type V3 {
  V3(x: Int, y: Int, z: Int)
}

pub fn add(a: V3, b: V3) -> V3 {
  V3(a.x + b.x, a.y + b.y, a.z + b.z)
}

pub fn subtract(a: V3, b: V3) -> V3 {
  add(a, invert(b))
}

pub fn invert(v: V3) -> V3 {
  V3(-v.x, -v.y, -v.z)
}
