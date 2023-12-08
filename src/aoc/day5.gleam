import gleam/bool
import gleam/int
import gleam/list
import gleam/string

pub type Range {
  Range(source: Int, destination: Int, length: Int)
}

pub type Map =
  List(Range)

pub type State {
  State(seeds: List(Int), maps: List(Map))
}

pub fn part1(input: String) -> Int {
  let state = parse(input)

  let assert Ok(location) =
    list.map(state.seeds, process_seed(_, state.maps))
    |> list.reduce(int.min)

  location
}

pub fn part2(_input: String) -> Int {
  -1
}

fn process_seed(seed: Int, maps: List(List(Range))) {
  use number, ranges <- list.fold(maps, seed)
  use number, range <- list.fold_until(ranges, number)

  let found = find(number, range)
  case number == found {
    False -> list.Stop(found)
    True -> list.Continue(number)
  }
}

fn find(number: Int, range: Range) -> Int {
  let Range(source_start, dest_start, length) = range
  let source_end = source_start + length
  let dest_end = dest_start + length
  use <- bool.guard(number < source_start || number > source_end, number)

  let assert Ok(dest_mid) = int.floor_divide({ dest_start + dest_end }, 2)
  let assert Ok(length) = int.floor_divide(length, 2)
  let assert Ok(source_mid) = int.floor_divide({ source_start + source_end }, 2)

  use <- bool.guard(
    source_mid < number,
    find(number, Range(source_mid + 1, dest_mid + 1, length + 1)),
  )

  use <- bool.guard(
    source_mid > number,
    find(number, Range(source_start, dest_start, length - 1)),
  )

  dest_mid
}

fn parse(input: String) {
  use <- reverse_maps
  let lines = string.split(input, "\n")
  let state = State(seeds: [], maps: [])
  use state, line <- list.fold(lines, state)

  case line {
    "seeds: " <> seeds -> parse_seeds(state, seeds)

    "seed-to-soil map:" -> new_map(state)
    "soil-to-fertilizer map:" -> new_map(state)
    "fertilizer-to-water map:" -> new_map(state)
    "water-to-light map:" -> new_map(state)
    "light-to-temperature map:" -> new_map(state)
    "temperature-to-humidity map:" -> new_map(state)
    "humidity-to-location map:" -> new_map(state)

    "" -> state

    numbers -> add_range(state, numbers)
  }
}

fn reverse_maps(to_state: fn() -> State) -> State {
  let state = to_state()
  let maps =
    list.map(state.maps, list.reverse)
    |> list.reverse
  State(..state, maps: maps)
}

fn new_map(state) {
  State(..state, maps: [[], ..state.maps])
}

fn parse_seeds(state, string) {
  let seeds =
    string.split(string, " ")
    |> list.filter_map(int.parse)

  State(..state, seeds: seeds)
}

fn add_range(state: State, numbers: String) -> State {
  let assert [destination, source, length] =
    string.split(numbers, " ")
    |> list.filter_map(int.parse)

  let assert [map, ..maps] = state.maps
  let range = Range(source, destination, length)
  let maps = [[range, ..map], ..maps]

  State(..state, maps: maps)
}
