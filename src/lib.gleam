import gleam/list
import gleam/string

pub type Vector {
  Vector(x: Int, y: Int)
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
