import gleam/list
import gleam/option.{type Option, Some, None}
import gleam/string
import gleam/dict.{type Dict}

const forbidden_chars = [",", "\n", ":", ".", "!", "&", "@", "$", "%", "^", "&"]

pub fn count_words(input: String) -> Dict(String, Int) {
  forbidden_chars
  |> list.fold(input, fn(acc, x) { string.replace(acc, x, " ") })
  |> string.replace("'", "")
  |> string.lowercase
  |> string.split(on: " ")
  |> list.filter(fn(x) { x != "" })
  |> list.fold(
    dict.new(),
    fn(dict, word) { dict.update(dict, maybe_fix_word(word), increment) },
  )
}

fn increment(count: Option(Int)) -> Int {
  case count {
    Some(i) -> i + 1
    None -> 1
  }
}

fn maybe_fix_word(word: String) -> String {
  case word {
    "dont" -> "don't"
    "youre" -> "you're"
    "cant" -> "can't"
    _ -> word
  }
}
