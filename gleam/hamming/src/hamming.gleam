import gleam/int
import gleam/list
import gleam/string

pub fn distance(strand1: String, strand2: String) -> Result(Int, Nil) {
  case string.length(strand1) == string.length(strand2) {
    True ->
      list.map2(
        string.to_graphemes(strand1),
        string.to_graphemes(strand2),
        fn(n1, n2) {
          case n1 == n2 {
            True -> 0
            False -> 1
          }
        },
      )
      |> int.sum
      |> Ok
    False -> Error(Nil)
  }
}
