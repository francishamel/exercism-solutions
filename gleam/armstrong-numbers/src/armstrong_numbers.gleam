import gleam/int
import gleam/list

pub fn is_armstrong_number(number: Int) -> Bool {
  let assert Ok(digits) = int.digits(number, 10)

  digits
  |> list.map(fn(x) { power(x, list.length(digits)) })
  |> int.sum == number
}

fn power(base: Int, exponent: Int) -> Int {
  do_power(base, exponent, 1)
}

fn do_power(base: Int, exponent: Int, acc: Int) -> Int {
  case exponent {
    0 -> acc
    n -> do_power(base, n - 1, acc * base)
  }
}
