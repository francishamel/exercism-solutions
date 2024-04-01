import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn row(index: Int, string: String) -> Result(List(Int), Nil) {
  string
  |> to_matrix
  |> result.try(list.at(_, index - 1))
}

pub fn column(index: Int, string: String) -> Result(List(Int), Nil) {
  string
  |> to_matrix
  |> result.try(list.try_map(_, list.at(_, index - 1)))
}

fn to_matrix(string: String) -> Result(List(List(Int)), Nil) {
  string
  |> string.split("\n")
  |> list.map(string.split(_, " "))
  |> list.try_map(list.try_map(_, int.parse))
}
