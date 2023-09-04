import gleam/int

pub type Error {
  NonPositiveNumber
}

pub fn steps(number: Int) -> Result(Int, Error) {
  case number {
    number if number <= 0 -> Error(NonPositiveNumber)
    number -> Ok(do_steps(number, 0))
  }
}

fn do_steps(number: Int, iteration: Int) -> Int {
  case number {
    1 -> iteration
    number ->
      case int.is_even(number) {
        True -> do_steps(number / 2, iteration + 1)
        False -> do_steps(3 * number + 1, iteration + 1)
      }
  }
}
