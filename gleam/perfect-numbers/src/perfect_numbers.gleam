import gleam/int
import gleam/list
import gleam/order.{Eq, Gt, Lt}

pub type Classification {
  Perfect
  Abundant
  Deficient
}

pub type Error {
  NonPositiveInt
}

pub fn classify(number: Int) -> Result(Classification, Error) {
  case number > 0 {
    True ->
      case int.compare(aliquot_sum(number), number) {
        Eq -> Ok(Perfect)
        Gt -> Ok(Abundant)
        Lt -> Ok(Deficient)
      }
    False -> Error(NonPositiveInt)
  }
}

fn aliquot_sum(number: Int) -> Int {
  list.range(from: 1, to: number / 2)
  |> list.filter(fn(x) { x != number && number % x == 0 })
  |> int.sum()
}
