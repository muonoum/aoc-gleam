import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string

pub type Token {
  Workflow(String, List(Rule))
  Rating(Dict(String, Int))
}

pub type Rule {
  Check(Check, Action)
  Action(Action)
}

pub type Check {
  Less(String, Int)
  More(String, Int)
}

pub type Action {
  Accept
  Reject
  Send(String)
}

pub fn part1(input: String) -> Int {
  let #(workflows, ratings) = parse(input)
  let assert Ok(start) = dict.get(workflows, "in")

  int.sum({
    use rating <- list.map({
      use rating <- list.filter_map(ratings)
      process(rating, start, workflows)
    })

    dict.values(rating)
    |> int.sum
  })
}

pub fn part2(_input: String) -> Int {
  -1
}

fn process(
  rating: Dict(String, Int),
  rules: List(Rule),
  workflows: Dict(String, List(Rule)),
) -> Result(Dict(String, Int), Nil) {
  let assert [rule, ..rest] = rules
  let process = process(rating, _, workflows)
  let send = send(rating, _, workflows)

  case rule {
    Action(Accept) -> Ok(rating)
    Action(Send(workflow)) -> send(workflow)
    Action(Reject) -> Error(Nil)

    Check(More(name, want), action) -> {
      case dict.get(rating, name), action {
        Ok(have), Accept if have > want -> Ok(rating)
        Ok(have), Send(workflow) if have > want -> send(workflow)
        Ok(have), Reject if have > want -> Error(Nil)
        Ok(_), _ -> process(rest)
        Error(Nil), _action -> panic
      }
    }

    Check(Less(name, want), action) -> {
      case dict.get(rating, name), action {
        Ok(have), Accept if have < want -> Ok(rating)
        Ok(have), Send(workflow) if have < want -> send(workflow)
        Ok(have), Reject if have < want -> Error(Nil)
        Ok(_), _ -> process(rest)
        Error(Nil), _action -> panic
      }
    }
  }
}

fn send(
  rating: Dict(String, Int),
  workflow: String,
  workflows: Dict(String, List(Rule)),
) -> Result(Dict(String, Int), Nil) {
  let assert Ok(workflow) = dict.get(workflows, workflow)
  process(rating, workflow, workflows)
}

pub fn parse(input: String) {
  let #(_, tokens) = {
    let lines = string.split(input, "\n")
    let parser = parse_workflow
    use #(parser, tokens), line <- list.fold(lines, #(parser, []))

    case line {
      "" -> #(parse_rating, tokens)
      line -> #(parser, [parser(line), ..tokens])
    }
  }

  let workflows =
    dict.from_list({
      use token <- list.filter_map(tokens)
      case token {
        Workflow(name, workflow) -> Ok(#(name, workflow))
        _else -> Error(Nil)
      }
    })

  let ratings = {
    use token <- list.filter_map(tokens)
    case token {
      Rating(rating) -> Ok(rating)
      _else -> Error(Nil)
    }
  }

  #(workflows, list.reverse(ratings))
}

fn parse_workflow(line: String) -> Token {
  let assert [name, rules] = string.split(line, "{")
  let rules =
    string.replace(rules, "}", "")
    |> string.split(",")
    |> list.map(parse_rule)

  Workflow(name, rules)
}

fn parse_rule(rule: String) -> Rule {
  case string.split(rule, ":") {
    [cond, action] -> Check(parse_check(cond), parse_action(action))
    [action] -> Action(parse_action(action))
    _else -> panic
  }
}

fn parse_check(check: String) -> Check {
  case string.split(check, "<") {
    [rating, number] -> {
      let assert Ok(number) = int.parse(number)
      Less(rating, number)
    }

    _else ->
      case string.split(check, ">") {
        [rating, number] -> {
          let assert Ok(number) = int.parse(number)
          More(rating, number)
        }

        _else -> panic
      }
  }
}

fn parse_action(action: String) -> Action {
  case action {
    "A" -> Accept
    "R" -> Reject
    workflow -> Send(workflow)
  }
}

fn parse_rating(line: String) {
  Rating(
    dict.from_list({
      use rating <- list.map(
        string.replace(line, "{", "")
        |> string.replace("}", "")
        |> string.split(","),
      )

      let assert [name, value] = string.split(rating, "=")
      let assert Ok(number) = int.parse(value)
      #(name, number)
    }),
  )
}
