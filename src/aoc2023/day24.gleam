import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import lib/float/v2.{type V2, V2}
import lib/read

pub fn part1(input: String) -> Int {
  let hail = parse(input)

  let #(min, max) = case list.length(hail) {
    5 -> #(7.0, 27.0)
    _ -> #(200_000_000_000_000.0, 400_000_000_000_000.0)
  }

  list.length({
    use #(a, b) <- list.filter_map(list.combination_pairs(hail))
    use V2(x, y) as point <- result.try(intersection(a, b))
    let bad_position = x <. min || x >. max || y <. min || y >. max
    let bad_time = past(a, point) || past(b, point)
    use <- bool.guard(bad_position || bad_time, Error(Nil))
    Ok(point)
  })
}

pub fn part2(_input: String) -> Int {
  -1
}

fn intersection(pv1: #(V2, V2), pv2: #(V2, V2)) -> Result(V2, Nil) {
  // y = mx + b
  let #(p1, v1) = pv1
  let #(p2, v2) = pv2
  let slope1 = v1.y /. v1.x
  let slope2 = v2.y /. v2.x
  let intercept1 = p1.y -. slope1 *. p1.x
  let intercept2 = p2.y -. slope2 *. p2.x
  use <- bool.guard(slope1 == slope2, Error(Nil))
  let x = { intercept2 -. intercept1 } /. { slope1 -. slope2 }
  let y = slope1 *. x +. intercept1
  Ok(V2(x, y))
}

fn past(pv: #(V2, V2), p2: V2) -> Bool {
  let #(p1, v1) = pv
  let x = { p2.x -. p1.x } /. v1.x
  let y = { p2.y -. p1.y } /. v1.y
  x <. 0.0 && y <. 0.0
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))
  let assert [position, velocity] = read.fields(line, "@")

  let assert [px, py, _pz] =
    read.integers(position, ",")
    |> list.map(int.to_float)

  let assert [vx, vy, _vz] =
    read.integers(velocity, ",")
    |> list.map(int.to_float)

  #(V2(px, py), V2(vx, vy))
}
