import gleam/int
import gleam/list

pub type Resistance {
  Resistance(unit: String, value: Int)
}

pub fn label(colors: List(String)) -> Result(Resistance, Nil) {
  case list.try_map(colors, color_to_digit) {
    Ok([d1, d2, d3, ..]) -> Ok(digits_to_resistance(d1, d2, d3))
    Error(_) -> Error(Nil)
  }
}

fn color_to_digit(color: String) -> Result(Int, Nil) {
  case color {
    "black" -> Ok(0)
    "brown" -> Ok(1)
    "red" -> Ok(2)
    "orange" -> Ok(3)
    "yellow" -> Ok(4)
    "green" -> Ok(5)
    "blue" -> Ok(6)
    "violet" -> Ok(7)
    "grey" -> Ok(8)
    "white" -> Ok(9)
    _ -> Error(Nil)
  }
}

fn digits_to_resistance(d1: Int, d2: Int, d3: Int) -> Resistance {
  let digits = [d1, d2, ..list.repeat(0, d3)]
  let assert Ok(numeric_value) = int.undigits(digits, 10)
  case numeric_value {
    x if x >= 1_000_000_000 ->
      Resistance(unit: "gigaohms", value: x / 1_000_000_000)
    x if x >= 1_000_000 -> Resistance(unit: "megaohms", value: x / 1_000_000)
    x if x >= 1000 -> Resistance(unit: "kiloohms", value: x / 1000)
    x -> Resistance(unit: "ohms", value: x)
  }
}
