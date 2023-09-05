import gleam/float
import gleam/int
import gleam/list
import gleam/result

pub type Error {
  InvalidSquare
}

pub fn square(square: Int) -> Result(Int, Error) {
  case 1 <= square && square <= 64 {
    True -> {
      let assert Ok(square_float) = int.power(2, int.to_float(square - 1))
      Ok(float.truncate(square_float))
    }
    False -> Error(InvalidSquare)
  }
}

pub fn total() -> Int {
  list.range(from: 1, to: 64)
  |> list.map(square)
  |> result.values
  |> int.sum
}
