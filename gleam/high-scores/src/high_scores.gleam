import gleam/int
import gleam/list

pub fn scores(high_scores: List(Int)) -> List(Int) {
  high_scores
}

pub fn latest(high_scores: List(Int)) -> Result(Int, Nil) {
  list.last(high_scores)
}

pub fn personal_best(high_scores: List(Int)) -> Result(Int, Nil) {
  list.reduce(high_scores, fn(acc, x) { int.max(acc, x) })
}

pub fn personal_top_three(high_scores: List(Int)) -> List(Int) {
  high_scores
  |> list.sort(fn(x1, x2) { int.compare(x2, x1) })
  |> list.take(3)
}
