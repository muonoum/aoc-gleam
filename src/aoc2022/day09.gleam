import gleam/bool
import gleam/int.{absolute_value as abs}
import gleam/list
import gleam/pair
import gleam/set
import gleam_community/maths/piecewise.{int_sign as sign}
import lib/int/vector.{type V2, V2}
import lib/read

pub fn part1(input: String) -> Int {
  solve(input, 2)
}

pub fn part2(input: String) -> Int {
  solve(input, 10)
}

fn solve(input: String, count: Int) -> Int {
  set.size(
    pair.second({
      let state = #(create(count), set.new())
      use state, #(direction, moves) <- list.fold(parse(input), state)
      use #(knots, visited), _ <- list.fold(moves, state)

      let assert [tail, ..] as knots = {
        use knots, knot <- list.fold(knots, [])
        case knots {
          [] -> [vector.add2(knot, direction)]
          [leader, ..] -> {
            [vector.add2(knot, move(knot, leader)), ..knots]
          }
        }
      }

      #(list.reverse(knots), set.insert(visited, tail))
    }),
  )
}

fn create(count: Int) -> List(V2) {
  use _ <- list.map(list.range(1, count))
  V2(0, 0)
}

fn move(follower: V2, leader: V2) -> V2 {
  let V2(dx, dy) = vector.subtract2(leader, follower)
  use <- bool.guard(abs(dx) <= 1 && abs(dy) <= 1, V2(0, 0))
  V2(sign(dx), sign(dy))
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))
  let assert [direction, count] = read.fields(line, " ")
  let assert Ok(count) = int.parse(count)
  #(parse_direction(direction), list.range(1, count))
}

fn parse_direction(string: String) -> V2 {
  case string {
    "D" -> V2(0, 1)
    "L" -> V2(-1, 0)
    "R" -> V2(1, 0)
    "U" -> V2(0, -1)
    _else -> panic
  }
}
