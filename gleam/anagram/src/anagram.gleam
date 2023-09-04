import gleam/list
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  candidates
  |> list.filter(fn(candidate) {
    string.lowercase(word) != string.lowercase(candidate) && standardize_string(
      word,
    ) == standardize_string(candidate)
  })
}

fn standardize_string(str: String) -> String {
  str
  |> string.lowercase
  |> string.to_graphemes
  |> list.sort(string.compare)
  |> string.concat
}
