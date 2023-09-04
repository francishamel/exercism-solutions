import gleam/list
import gleam/string

pub type Error {
  EmptySeries
  SliceLengthNegative
  SliceLengthTooLarge
  SliceLengthZero
}

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  let input_length = string.length(input)

  case string.to_graphemes(input) {
    [] -> Error(EmptySeries)
    _ if size == 0 -> Error(SliceLengthZero)
    _ if size < 0 -> Error(SliceLengthNegative)
    _ if size > input_length -> Error(SliceLengthTooLarge)
    chars ->
      chars
      |> list.window(by: size)
      |> list.map(string.concat)
      |> Ok
  }
}
