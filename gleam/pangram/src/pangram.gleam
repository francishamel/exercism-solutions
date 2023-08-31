import gleam/set
import gleam/string

const all_letters = [
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
  "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
]

pub fn is_pangram(sentence: String) -> Bool {
  let pangram_set = set.from_list(all_letters)

  {
    sentence
    |> string.lowercase
    |> string.to_graphemes
    |> set.from_list
    |> set.intersection(pangram_set)
  } == pangram_set
}
