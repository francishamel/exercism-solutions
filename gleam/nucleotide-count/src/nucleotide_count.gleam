import gleam/list
import gleam/map.{Map}
import gleam/option.{Option, Some}
import gleam/string

pub fn nucleotide_count(dna: String) -> Result(Map(String, Int), Nil) {
  let initial_map = map.from_list([#("A", 0), #("C", 0), #("G", 0), #("T", 0)])

  dna
  |> string.to_graphemes
  |> list.try_fold(
    initial_map,
    fn(map, nucleotide) {
      case nucleotide {
        "A" | "C" | "G" | "T" ->
          Ok(map.update(map, nucleotide, strict_increment))
        _ -> Error(Nil)
      }
    },
  )
}

fn strict_increment(count: Option(Int)) -> Int {
  let assert Some(i) = count
  i + 1
}
