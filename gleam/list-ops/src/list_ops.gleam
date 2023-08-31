pub fn append(first first: List(a), second second: List(a)) -> List(a) {
  do_append(reverse(first), second)
}

fn do_append(list: List(a), acc: List(a)) -> List(a) {
  case list {
    [] -> acc
    [head, ..tail] -> do_append(tail, [head, ..acc])
  }
}

pub fn concat(lists: List(List(a))) -> List(a) {
  do_concat(lists, [])
}

fn do_concat(lists: List(List(a)), acc: List(a)) -> List(a) {
  case lists {
    [] -> reverse(acc)
    [head, ..tail] -> do_concat(tail, do_append(head, acc))
  }
}

pub fn filter(list: List(a), function: fn(a) -> Bool) -> List(a) {
  do_filter(list, function, [])
}

fn do_filter(list: List(a), f: fn(a) -> Bool, acc: List(a)) -> List(a) {
  case list {
    [] -> reverse(acc)
    [head, ..tail] ->
      case f(head) {
        True -> do_filter(tail, f, [head, ..acc])
        False -> do_filter(tail, f, acc)
      }
  }
}

pub fn length(list: List(a)) -> Int {
  do_length(list, 0)
}

fn do_length(list: List(a), count: Int) -> Int {
  case list {
    [] -> count
    [_, ..tail] -> do_length(tail, count + 1)
  }
}

pub fn map(list: List(a), function: fn(a) -> b) -> List(b) {
  do_map(list, function, [])
}

fn do_map(list: List(a), f: fn(a) -> b, acc: List(b)) -> List(b) {
  case list {
    [] -> reverse(acc)
    [head, ..tail] -> do_map(tail, f, [f(head), ..acc])
  }
}

pub fn foldl(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  case list {
    [] -> initial
    [head, ..tail] -> foldl(tail, function(initial, head), function)
  }
}

pub fn foldr(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  foldl(reverse(list), initial, function)
}

pub fn reverse(list: List(a)) -> List(a) {
  do_reverse(list, [])
}

fn do_reverse(list: List(a), acc: List(a)) -> List(a) {
  case list {
    [] -> acc
    [head, ..tail] -> do_reverse(tail, [head, ..acc])
  }
}
