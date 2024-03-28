import gleam/list
import gleam/dict.{type Dict}
import gleam/option.{type Option, Some}
import gleam/string

pub fn nucleotide_count(dna: String) -> Result(Dict(String, Int), Nil) {
  let initial_dict = dict.from_list([#("A", 0), #("C", 0), #("G", 0), #("T", 0)])

  dna
  |> string.to_graphemes
  |> list.try_fold(
    initial_dict,
    fn(map, nucleotide) {
      case nucleotide {
        "A" | "C" | "G" | "T" ->
          Ok(dict.update(map, nucleotide, strict_increment))
        _ -> Error(Nil)
      }
    },
  )
}

fn strict_increment(count: Option(Int)) -> Int {
  let assert Some(i) = count
  i + 1
}
