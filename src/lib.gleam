import gleam/list
import gleam/string

pub type Vector {
  Vector(x: Int, y: Int)
}

pub fn add_vector(a: Vector, b: Vector) -> Vector {
  Vector(a.x + b.x, a.y + b.y)
}

pub fn return(a: fn(a) -> b, body: fn() -> a) -> b {
  a(body())
}

pub fn lines(input: String) -> List(String) {
  use line <- list.map({
    use line <- list.filter(string.split(input, "\n"))
    line != ""
  })

  line
}
