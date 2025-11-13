import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import lib/read

pub type Almanac =
  #(List(Int), List(List(Map)))

pub type Map {
  Map(range: Range, shift: Int)
}

pub type Range {
  Range(start: Int, end: Int)
}

pub fn part1(input: String) -> Int {
  let #(seeds, maps) = parse(input)

  process(maps, {
    use seed <- list.map(seeds)
    Range(seed, seed + 1)
  })
}

pub fn part2(input: String) -> Int {
  let #(seeds, maps) = parse(input)

  process(maps, {
    use range <- list.map(list.sized_chunk(seeds, 2))
    let assert [start, length] = range
    Range(start, start + length)
  })
}

fn process(maps: List(List(Map)), ranges: List(Range)) -> Int {
  minimum({
    use range <- list.map({
      use ranges, step <- list.fold(maps, ranges)
      let ranges = shift(ranges, step)
      use Range(start, end) <- list.filter(ranges)
      start < end
    })

    range.start
  })
}

fn shift(ranges: List(Range), step: List(Map)) -> List(Range) {
  use Range(start, end) <- list.flat_map(ranges)

  let #(start, ranges) = {
    use #(start, ranges), Map(map, shift) <- list.fold(step, { #(start, []) })

    let ranges = [
      Range(start, int.min(map.start, end)),
      Range(int.max(map.start, start) + shift, int.min(map.end, end) + shift),
      ..ranges
    ]

    let next = int.max(start, int.min(map.end, end))
    #(next, ranges)
  }

  [Range(start, end), ..ranges]
}

fn minimum(ranges: List(Int)) -> Int {
  let assert Ok(minimum) = list.reduce(ranges, int.min)
  minimum
}

fn parse(input: String) -> Almanac {
  use <- sort_and_reverse
  let lines = read.lines(input)
  use #(seeds, maps), line <- list.fold(lines, #([], []))

  case line {
    "seeds: " <> seeds -> {
      let seeds =
        string.split(seeds, " ")
        |> list.filter_map(int.parse)

      #(seeds, maps)
    }

    "seed-to-soil map:"
    | "soil-to-fertilizer map:"
    | "fertilizer-to-water map:"
    | "water-to-light map:"
    | "light-to-temperature map:"
    | "temperature-to-humidity map:"
    | "humidity-to-location map:" -> {
      #(seeds, [[], ..maps])
    }

    "" -> #(seeds, maps)

    numbers -> {
      let assert [destination, source, length] = read.integers(numbers, " ")
      let assert [step, ..maps] = maps
      let range = Range(source, source + length)
      let map = Map(range, destination - source)
      #(seeds, [[map, ..step], ..maps])
    }
  }
}

fn sort_and_reverse(almanac: fn() -> Almanac) -> Almanac {
  use maps <- pair.map_second(almanac())

  list.reverse({
    use map <- list.map(maps)
    use Map(Range(a, _), _), Map(Range(b, _), _) <- list.sort(map)
    int.compare(a, b)
  })
}
