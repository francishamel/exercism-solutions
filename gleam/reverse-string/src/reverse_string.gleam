import gleam/string

pub fn reverse(value: String) -> String {
  value
  |> string.to_graphemes
  |> do_reverse([])
}

fn do_reverse(in: List(String), out: List(String)) -> String {
  case in {
    [] -> string.concat(out)
    [first, ..rest] -> do_reverse(rest, [first, ..out])
  }
}
