import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/string
import gleam/string_builder as sb

type GameResult {
  Win(team: String)
  Loss(team: String)
  Draw(team: String)
}

type Stats {
  Stats(name: String, mp: Int, w: Int, d: Int, l: Int, p: Int)
}

const header = "Team                           | MP |  W |  D |  L |  P"

pub fn tally(input: String) -> String {
  use <- bool.guard(string.is_empty(input), header)

  input
  |> parse_stats
  |> print_tally
}

fn parse_stats(input: String) -> List(Stats) {
  input
  |> string.split("\n")
  |> list.flat_map(fn(line) {
    let assert [team1, team2, result] = string.split(line, ";")

    case result {
      "win" -> [Win(team1), Loss(team2)]
      "loss" -> [Win(team2), Loss(team1)]
      "draw" -> [Draw(team1), Draw(team2)]
      _ -> panic
    }
  })
  |> list.fold(dict.new(), fn(acc, game_result) {
    dict.update(acc, game_result.team, fn(team) {
      let team = option.unwrap(team, Stats(game_result.team, 0, 0, 0, 0, 0))

      case game_result {
        Win(..) -> Stats(..team, mp: team.mp + 1, w: team.w + 1, p: team.p + 3)
        Loss(..) -> Stats(..team, mp: team.mp + 1, l: team.l + 1)
        Draw(..) -> Stats(..team, mp: team.mp + 1, d: team.d + 1, p: team.p + 1)
      }
    })
  })
  |> dict.values
  |> list.sort(fn(t1, t2) { int.compare(t2.p, t1.p) })
}

fn print_tally(stats: List(Stats)) -> String {
  stats
  |> list.map(fn(team) {
    [team.mp, team.w, team.d, team.l, team.p]
    |> list.map(int.to_string)
    |> list.map(string.pad_left(_, to: 2, with: " "))
    |> list.prepend(string.pad_right(team.name, to: 30, with: " "))
    |> list.map(sb.from_string)
    |> sb.join(" | ")
  })
  |> list.prepend(sb.from_string(header))
  |> sb.join("\n")
  |> sb.to_string
}
