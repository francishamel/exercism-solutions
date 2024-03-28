import gleam/int
import gleam/result

pub fn egg_count(number: Int) -> Int {
  number
  |> int.digits(2)
  |> result.unwrap([])
  |> int.sum
}
