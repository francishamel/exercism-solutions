import gleam/list
import gleam/map.{Map}
import gleam/string

pub fn transform(legacy: Map(Int, List(String))) -> Map(String, Int) {
  legacy
  |> map.to_list
  |> list.flat_map(fn(legacy_pair) {
    list.map(
      legacy_pair.1,
      fn(letter) { #(string.lowercase(letter), legacy_pair.0) },
    )
  })
  |> map.from_list
}
