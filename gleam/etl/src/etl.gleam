import gleam/list
import gleam/string
import gleam/dict.{type Dict}

pub fn transform(legacy: Dict(Int, List(String))) -> Dict(String, Int) {
  legacy
  |> dict.to_list
  |> list.flat_map(fn(legacy_pair) {
    list.map(
      legacy_pair.1,
      fn(letter) { #(string.lowercase(letter), legacy_pair.0) },
    )
  })
  |> dict.from_list
}
