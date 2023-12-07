import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/iterator.{type Iterator}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/otp/task
import gleam/string

const map_order = [
  "seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light",
  "light-to-temperature", "temperature-to-humidity", "humidity-to-location",
]

pub type Range =
  #(Int, Int, Iterator(#(Int, Int)))

pub type State {
  State(name: Option(String), seeds: List(Int), maps: Dict(String, List(Range)))
}

type Step {
  Process(Int)
  Done(Int)
}

pub fn part1(input: String) -> Int {
  let state = parse(input)

  let assert [location, ..] =
    list.map(state.seeds, fn(seed) {
      use <- task.async
      process_seed(seed, state.maps)
    })
    |> list.map(task.await_forever)
    |> list.sort(int.compare)

  location
}

pub fn part2(_input: String) -> Int {
  -1
}

fn step_done(seed, name, f) {
  let v = f()
  io.debug(#("done", seed, name, v))
  v
}

fn process_seed(seed: Int, maps: Dict(String, List(Range))) {
  use number, name <- list.fold(map_order, seed)
  io.debug(#("start", seed, name))
  use <- step_done(seed, name)
  let assert Ok(ranges) = dict.get(maps, name)
  use number, range <- list.fold_until(ranges, number)

  case range {
    #(start, end, _) if number < start || number > end -> {
      list.Continue(number)
    }

    #(_, _, iter) -> {
      let step = {
        use number, map <- iterator.fold_until(iter, Process(number))
        let #(source, destination) = map

        let assert Process(number) = number
        case number == source {
          False -> list.Continue(Process(number))
          True -> list.Stop(Done(destination))
        }
      }

      case step {
        Process(number) -> list.Continue(number)
        Done(number) -> list.Stop(number)
      }
    }
  }
}

fn parse(input: String) {
  let state = State(name: None, seeds: [], maps: dict.new())
  use state, line <- list.fold(string.split(input, "\n"), state)

  case line, state.name {
    "seeds: " <> seeds, _name -> parse_seeds(state, seeds)

    "seed-to-soil map:", _name -> select_map(state, "seed-to-soil")
    "soil-to-fertilizer map:", _name -> select_map(state, "soil-to-fertilizer")
    "fertilizer-to-water map:", _name ->
      select_map(state, "fertilizer-to-water")
    "water-to-light map:", _name -> select_map(state, "water-to-light")
    "light-to-temperature map:", _name ->
      select_map(state, "light-to-temperature")
    "temperature-to-humidity map:", _name ->
      select_map(state, "temperature-to-humidity")
    "humidity-to-location map:", _name ->
      select_map(state, "humidity-to-location")

    "", _name -> state
    numbers, Some(name) -> add_range(state, name, numbers)
    _, None -> panic
  }
}

fn select_map(state, name) {
  State(..state, name: Some(name))
}

fn parse_seeds(state, string) {
  let seeds =
    string.split(string, " ")
    |> list.filter_map(int.parse)

  State(..state, seeds: seeds)
}

fn add_range(state: State, name: String, numbers: String) -> State {
  let assert [destination, source, length] =
    string.split(numbers, " ")
    |> list.filter_map(int.parse)

  let source_range = iterator.range(source, source + length)
  let dest_range = iterator.range(destination, destination + length)
  let iter = iterator.zip(source_range, dest_range)
  let range = #(source, source + length, iter)

  let maps =
    dict.insert(state.maps, name, {
      case dict.get(state.maps, name) {
        Error(Nil) -> [range]
        Ok(ranges) -> list.append(ranges, [range])
      }
    })

  State(..state, maps: maps)
}
