import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option
import gleam/pair
import lib
import lib/read

pub type Tokens {
  Top
  List
  Exit
  Enter(String)
  Directory(String)
  File(Int, String)
}

pub fn part1(input: String) -> Int {
  int.sum({
    use #(_name, size) <- list.filter_map(dict.to_list(scan(input)))
    use <- bool.guard(size > 100_000, Error(Nil))
    Ok(size)
  })
}

pub fn part2(input: String) -> Int {
  let sizes = scan(input)

  let assert Ok(root) = dict.get(sizes, ["/"])
  let wanted = 30_000_000 - { 70_000_000 - root }
  let candidates =
    dict.to_list({
      use _, size <- dict.filter(sizes)
      size >= wanted
    })

  let assert Ok(#(_, to_delete)) =
    list.first({
      use #(_, a), #(_, b) <- list.sort(candidates)
      int.compare(a, b)
    })

  to_delete
}

fn scan(input: String) -> Dict(List(String), Int) {
  use <- lib.return(pair.first)
  let state = #(dict.new(), ["/"])
  use #(sizes, dirs), token <- list.fold(parse(input), state)

  case token {
    Top -> #(sizes, dirs)

    Enter(dir) -> #(sizes, [dir, ..dirs])

    Exit -> {
      let assert [_, ..dirs] = dirs
      #(sizes, dirs)
    }

    List -> #(sizes, dirs)

    Directory(_) -> #(sizes, dirs)

    File(size, _) -> {
      let sizes = {
        use sizes, n <- list.fold(list.range(0, list.length(dirs) - 1), sizes)
        let key =
          list.drop(dirs, n)
          |> list.reverse
        use existing <- dict.upsert(sizes, key)
        option.map(existing, int.add(_, size))
        |> option.unwrap(size)
      }

      #(sizes, dirs)
    }
  }
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))

  case line {
    "$ cd /" -> Top
    "$ cd .." -> Exit
    "$ cd " <> dir -> Enter(dir)
    "$ ls" -> List
    entry ->
      case read.fields(entry, " ") {
        ["dir", dir] -> Directory(dir)
        [size, name] -> {
          let assert Ok(size) = int.parse(size)
          File(size, name)
        }
        _else -> panic
      }
  }
}
