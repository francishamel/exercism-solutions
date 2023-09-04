import gleam/list
import gleam/set
import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  let phrase_letters =
    phrase
    |> string.lowercase
    |> string.to_graphemes
    |> list.filter(fn(x) { x != " " && x != "," && x != "-" })

  phrase_letters
  |> list.length == phrase_letters
  |> set.from_list
  |> set.size
}
