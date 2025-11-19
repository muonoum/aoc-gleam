import gleam/dict
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lib/int/v2.{type V2, V2}
import lib/read

pub type Robot {
  Robot(position: V2, velocity: V2)
}

pub fn part1(input: String) -> Int {
  let robots = parse(input)
  run(robots, seconds: 100, space: V2(101, 103))
}

fn run(robots: List(Robot), seconds seconds: Int, space space: V2) -> Int {
  let robots = {
    let seconds = list.range(1, seconds)
    use robots, _second <- list.fold(seconds, robots)
    move(robots, space)
  }

  list.filter_map(robots, quadrant(_, space))
  |> list.group(function.identity)
  |> dict.values
  |> list.map(list.length)
  |> list.fold(1, int.multiply)
}

fn move(robots: List(Robot), space: V2) -> List(Robot) {
  use robot <- list.map(robots)
  let position = robot.position |> v2.add(robot.velocity)
  let position = V2(wrap(position.x, space.x), wrap(position.y, space.y))
  Robot(..robot, position:)
}

fn wrap(value: Int, limit: Int) -> Int {
  case value {
    v if v >= limit -> v - limit
    v if v < 0 -> limit + v
    v -> v
  }
}

fn quadrant(robot: Robot, space: V2) -> Result(Int, Nil) {
  case v2.subtract(robot.position, V2(space.x / 2, space.y / 2)) {
    V2(x:, y:) if x == 0 || y == 0 -> Error(Nil)
    V2(x:, y:) if x < 0 && y > 0 -> Ok(1)
    V2(x:, y:) if x > 0 && y > 0 -> Ok(2)
    V2(x:, y:) if x < 0 && y < 0 -> Ok(3)
    V2(x:, y:) if x > 0 && y < 0 -> Ok(4)
    v -> panic as string.inspect(v)
  }
}

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))

  let assert [[px, py], [vx, vy]] =
    read.fields(line, " ")
    |> list.map(string.drop_start(_, 2))
    |> list.map(read.integers(_, ","))

  Robot(position: V2(px, py), velocity: V2(vx, vy))
}
