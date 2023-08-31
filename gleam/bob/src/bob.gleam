import gleam/set
import gleam/string

const all_letters = [
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
  "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
]

pub fn hey(remark: String) -> String {
  case is_question(remark), is_yelled(remark), is_silence(remark) {
    True, False, False -> "Sure."
    False, True, False -> "Whoa, chill out!"
    True, True, False -> "Calm down, I know what I'm doing!"
    _, _, True -> "Fine. Be that way!"
    _, _, _ -> "Whatever."
  }
}

fn is_question(remark: String) -> Bool {
  remark
  |> string.trim
  |> string.ends_with("?")
}

fn is_yelled(remark: String) -> Bool {
  has_letters(remark) && string.uppercase(remark) == remark
}

fn has_letters(remark: String) -> Bool {
  remark
  |> string.lowercase
  |> string.to_graphemes
  |> set.from_list
  |> set.intersection(set.from_list(all_letters))
  |> set.to_list != []
}

fn is_silence(remark: String) -> Bool {
  remark
  |> string.trim
  |> string.is_empty
}
