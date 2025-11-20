import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import lib/int/v2.{type V2}
import lib/read

pub fn part1(input: String) -> Int {
  let grid = parse(input)
  let dict = dict.from_list(grid)

  list.length({
    use #(start, cell) <- list.flat_map(grid)
    use <- bool.guard(cell != "X", [])
    use direction <- list.filter_map(v2.directions)

    find(dict, "M", #(start, direction))
    |> result.try(find(dict, "A", _))
    |> result.try(find(dict, "S", _))
  })
}

pub fn part2(input: String) -> Int {
  let grid = parse(input)
  let dict = dict.from_list(grid)

  let ms = fn(start, direction) {
    use _ <- result.try(find(dict, "M", #(start, direction)))
    use _ <- result.try(find(dict, "S", #(start, v2.invert(direction))))
    Ok(#(start, direction))
  }

  let xmas = {
    use #(start, direction) <- list.flat_map({
      use #(start, cell) <- list.flat_map(grid)
      use <- bool.guard(cell != "A", [])
      list.filter_map(v2.intercardinals, ms(start, _))
    })

    [v2.invert_x(direction), v2.invert_y(direction)]
    |> list.filter_map(ms(start, _))
  }

  list.length(xmas) / 2
}

pub fn find(
  dict: Dict(V2, String),
  target: String,
  where: #(V2, V2),
) -> Result(#(V2, V2), Nil) {
  let #(start, direction) = where
  let position = v2.add(start, direction)
  use neighbor <- result.try(dict.get(dict, position))
  use <- bool.guard(neighbor == target, Ok(#(position, direction)))
  Error(Nil)
}

pub fn parse(input: String) -> List(#(V2, String)) {
  read.grid(input) |> v2.grid
}
