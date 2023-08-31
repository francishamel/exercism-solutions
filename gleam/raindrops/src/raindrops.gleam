import gleam/int

pub fn convert(number: Int) -> String {
  do_convert(number, [3, 5, 7], "")
}

fn do_convert(number: Int, factors: List(Int), acc: String) -> String {
  case factors, acc {
    [], "" -> int.to_string(number)
    [], acc -> acc
    [factor, ..rest], acc ->
      do_convert(number, rest, maybe_update_acc(acc, number, factor))
  }
}

fn maybe_update_acc(acc: String, number: Int, factor: Int) -> String {
  case factor, number % factor == 0 {
    3, True -> acc <> "Pling"
    5, True -> acc <> "Plang"
    7, True -> acc <> "Plong"
    _, _ -> acc
  }
}
