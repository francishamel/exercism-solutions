const roman_numeral_symbols = [
  #("M", 1000),
  #("CM", 900),
  #("D", 500),
  #("CD", 400),
  #("C", 100),
  #("XC", 90),
  #("L", 50),
  #("XL", 40),
  #("X", 10),
  #("IX", 9),
  #("V", 5),
  #("IV", 4),
  #("I", 1),
]

pub fn convert(number: Int) -> String {
  do_convert(number, roman_numeral_symbols, "")
}

fn do_convert(in: Int, symbols: List(#(String, Int)), out: String) -> String {
  case in, symbols {
    0, _ -> out
    in, [#(symbol, value), ..rest] if in >= value ->
      do_convert(in - value, [#(symbol, value), ..rest], out <> symbol)
    in, [_, ..rest] -> do_convert(in, rest, out)
    _, [] -> panic("impossible state")
  }
}
