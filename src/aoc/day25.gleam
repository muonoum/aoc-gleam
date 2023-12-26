import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import lib/read

pub fn part1(input: String) -> Int {
  // gleam run 25 | awk '/graph/{p=1;print;next}/}/{p=0;print}p' > graph.dot
  // dot -Tpng -o graph.png -Kneato graph.dot
  // ccomps -x graph.dot

  let graph = parse(input)
  let graph = case set.size(graph) {
    33 ->
      graph
      |> set.delete(#("hfx", "pzl"))
      |> set.delete(#("bvb", "cmg"))
      |> set.delete(#("nvd", "jqt"))
    _ ->
      graph
      |> set.delete(#("pzr", "sss"))
      |> set.delete(#("pbx", "njx"))
      |> set.delete(#("sxx", "zvk"))
  }

  print_graph(graph)
  -1
}

pub fn part2(_input: String) -> Int {
  -1
}

fn print_graph(graph: Set(#(String, String))) {
  let nodes = {
    use #(from, to) <- list.map(set.to_list(graph))
    from <> "--" <> to
  }

  let nodes = string.join(nodes, "\n")
  string.join(["graph {", nodes, "}"], "\n")
  |> io.println
}

pub fn parse(input: String) {
  set.from_list({
    use line <- list.flat_map(read.lines(input))
    let assert [part, connections] = read.fields(line, ":")
    let connections = read.fields(connections, " ")

    let right = {
      use other <- list.map(connections)
      #(other, part)
    }

    let left = {
      use other <- list.map(connections)
      #(other, part)
    }

    list.append(right, left)
  })
}
