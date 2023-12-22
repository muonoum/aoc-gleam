import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import lib.{type Vector}

pub type State {
  State(universe: List(Vector), columns: List(Int), rows: List(Int))
}

pub fn part1(input: String) -> Int {
  let state = parse(input)
  solve(state, 1)
}

pub fn part2(input: String) -> Int {
  let state = parse(input)
  solve(state, 1_000_000 - 1)
}

fn solve(state: State, factor: Int) {
  let State(universe, columns, rows) = state

  int.sum({
    use #(a, b) <- list.map(list.combination_pairs(universe))
    let #(ax, bx) = list.fold(columns, #(a.x, b.x), expand(by: factor))
    let #(ay, by) = list.fold(rows, #(a.y, b.y), expand(by: factor))
    let dx = int.absolute_value({ ax - bx })
    let dy = int.absolute_value({ ay - by })
    dx + dy
  })
}

fn expand(by factor: Int) {
  fn(pair: #(Int, Int), v: Int) {
    case pair {
      #(a, b) if a < v && b > v -> #(a - factor, b)
      #(a, b) if a > v && b < v -> #(a, b - factor)
      #(a, b) -> #(a, b)
    }
  }
}

fn parse(input: String) -> State {
  let lines = lib.lines(input)

  let rows = {
    use #(line, index) <- list.filter_map(list.index_map(lines, pair.new))
    use <- bool.guard(string.contains(line, "#"), Error(Nil))
    Ok(index)
  }

  let graphemes = list.map(lines, string.to_graphemes)

  let columns = {
    use #(line, index) <- list.filter_map(
      list.transpose(graphemes)
      |> list.map(string.join(_, ""))
      |> list.index_map(pair.new),
    )

    use <- bool.guard(string.contains(line, "#"), Error(Nil))
    Ok(index)
  }

  let grid = {
    use #(position, node) <- list.filter_map(lib.grid(graphemes))
    use <- bool.guard(node != "#", Error(Nil))
    Ok(position)
  }

  State(grid, columns, rows)
}
