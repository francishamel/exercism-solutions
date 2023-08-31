import gleam/list

pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  do_keep(list, predicate, [])
}

fn do_keep(list: List(t), predicate: fn(t) -> Bool, acc: List(t)) -> List(t) {
  case list {
    [] -> list.reverse(acc)
    [head, ..tail] ->
      case predicate(head) {
        True -> do_keep(tail, predicate, [head, ..acc])
        False -> do_keep(tail, predicate, acc)
      }
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  keep(list, fn(x) { !predicate(x) })
}
