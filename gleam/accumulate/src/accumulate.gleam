import gleam/list

pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  do_accumulate(list, fun, [])
}

fn do_accumulate(in: List(a), f: fn(a) -> b, out: List(b)) -> List(b) {
  case in {
    [] -> list.reverse(out)
    [first, ..rest] -> do_accumulate(rest, f, [f(first), ..out])
  }
}
