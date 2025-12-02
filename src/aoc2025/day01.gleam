import gleam/bool
import gleam/list
import lib/read

pub type State {
  State(value: Int, zero: Int)
}

type Turn =
  fn(State) -> State

pub fn part1(input: String) -> Int {
  let state = State(50, 0)
  parse(input) |> unlock1(state)
}

fn unlock1(turns: List(Turn), state: State) -> Int {
  case turns, state {
    [], state -> state.zero

    [turn, ..turns], State(zero:, ..) ->
      case turn(state).value {
        0 -> unlock1(turns, State(0, zero + 1))
        value -> unlock1(turns, State(value, zero))
      }
  }
}

pub fn part2(input: String) -> Int {
  let state = State(50, 0)
  parse(input) |> unlock2(state)
}

fn unlock2(turns: List(Turn), state: State) -> Int {
  case turns {
    [] -> state.zero
    [turn, ..turns] -> turn(state) |> unlock2(turns, _)
  }
}

fn parse(input: String) -> List(Turn) {
  use line <- list.map(read.lines(input))

  case line {
    "R" <> v -> turn(_, right, read.integer(v))
    "L" <> v -> turn(_, left, read.integer(v))
    _else -> panic
  }
}

fn turn(state: State, step: fn(State) -> State, count: Int) -> State {
  use <- bool.guard(count == 0, state)
  step(state) |> turn(step, count - 1)
}

fn left(state: State) -> State {
  case state.value - 1 {
    0 -> State(0, state.zero + 1)
    value if value < 0 -> State(99, state.zero)
    value -> State(..state, value:)
  }
}

fn right(state: State) -> State {
  case state.value + 1 {
    0 -> State(0, state.zero + 1)
    value if value > 99 -> State(0, state.zero + 1)
    value -> State(..state, value:)
  }
}
