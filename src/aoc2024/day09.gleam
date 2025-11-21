import gleam/deque.{type Deque}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import lib/read

pub type Span {
  File(id: Int, size: Int)
  Free(size: Int)
}

pub fn part1(input: String) -> Int {
  parse(input)
  |> expand_blocks
  |> deque.from_list
  |> compact_blocks([])
  |> checksum
}

fn checksum(blocks: List(Option(Int))) -> Int {
  int.sum({
    use block, index <- list.index_map(blocks)

    option.map(block, fn(v) { v * index })
    |> option.unwrap(0)
  })
}

fn compact_blocks(
  blocks: Deque(Option(Int)),
  result: List(Option(Int)),
) -> List(Option(Int)) {
  case deque.pop_front(blocks) {
    Error(Nil) -> list.reverse(result)
    Ok(#(Some(id), rest)) -> compact_blocks(rest, [Some(id), ..result])

    Ok(#(None, rest)) ->
      case deque.pop_back(rest) {
        Ok(#(None, rest)) ->
          compact_blocks(deque.push_front(rest, None), result)
        Ok(#(Some(id), rest)) -> compact_blocks(rest, [Some(id), ..result])
        Error(Nil) -> panic
      }
  }
}

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(input: String) -> List(Span) {
  list.flatten({
    use chunk, id <- list.index_map(
      read.integers(input, "")
      |> list.sized_chunk(2),
    )

    case chunk {
      [size] | [size, 0] -> [File(id:, size:)]
      [size, free] -> [File(id:, size:), Free(size: free)]
      _else -> panic
    }
  })
}

pub fn expand_blocks(spans: List(Span)) -> List(Option(Int)) {
  use block <- list.flat_map(spans)

  case block {
    Free(size:) -> list.repeat(None, size)
    File(id:, size:) -> list.repeat(Some(id), size)
  }
}
