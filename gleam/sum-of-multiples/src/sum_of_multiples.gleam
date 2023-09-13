import gleam/int
import gleam/list

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  list.range(1, limit - 1)
  |> list.filter(fn(candidate) {
    list.any(factors, fn(factor) { factor != 0 && candidate % factor == 0 })
  })
  |> int.sum
}
