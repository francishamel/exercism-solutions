import gleam/list
import gleam/result
import gleam/string

pub fn to_rna(dna: String) -> Result(String, Nil) {
  dna
  |> string.to_graphemes
  |> list.try_map(translate_dna)
  |> result.map(string.concat)
}

fn translate_dna(dna: String) -> Result(String, Nil) {
  case dna {
    "G" -> Ok("C")
    "C" -> Ok("G")
    "T" -> Ok("A")
    "A" -> Ok("U")
    _ -> Error(Nil)
  }
}
