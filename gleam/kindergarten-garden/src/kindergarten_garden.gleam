import gleam/list
import gleam/string

pub type Student {
  Alice
  Bob
  Charlie
  David
  Eve
  Fred
  Ginny
  Harriet
  Ileana
  Joseph
  Kincaid
  Larry
}

pub type Plant {
  Radishes
  Clover
  Violets
  Grass
}

pub fn plants(diagram: String, student: Student) -> List(Plant) {
  diagram
  |> string.split(on: "\n")
  |> list.flat_map(fn(row) { fetch_flowers_from_row(row, student) })
}

fn index_for_student(student: Student) -> Int {
  case student {
    Alice -> 0
    Bob -> 2
    Charlie -> 4
    David -> 6
    Eve -> 8
    Fred -> 10
    Ginny -> 12
    Harriet -> 14
    Ileana -> 16
    Joseph -> 18
    Kincaid -> 20
    Larry -> 22
  }
}

fn letter_to_plant(letter: String) -> Plant {
  case letter {
    "R" -> Radishes
    "C" -> Clover
    "V" -> Violets
    "G" -> Grass
    _ -> panic("this plant does not exist.")
  }
}

fn fetch_flowers_from_row(row: String, student: Student) -> List(Plant) {
  row
  |> string.slice(at_index: index_for_student(student), length: 2)
  |> string.to_graphemes
  |> list.map(letter_to_plant)
}
