import gleam/int
import gleam/list
import gleam/order.{type Order, Eq}
import gleam/string

pub type School {
  School(students: List(Student))
}

pub opaque type Student {
  Student(grade: Int, name: String)
}

pub fn create() -> School {
  School([])
}

pub fn roster(school: School) -> List(String) {
  school.students
  |> list.sort(by: sort_students)
  |> list.map(fn(s) { s.name })
}

fn sort_students(s1: Student, s2: Student) -> Order {
  case int.compare(s1.grade, s2.grade) {
    Eq -> string.compare(s1.name, s2.name)
    order -> order
  }
}

pub fn add(
  to school: School,
  student student: String,
  grade grade: Int,
) -> Result(School, Nil) {
  case list.find(school.students, fn(s) { s.name == student }) {
    Ok(..) -> Error(Nil)
    Error(..) -> Ok(School([Student(grade, student), ..school.students]))
  }
}

pub fn grade(school: School, desired_grade: Int) -> List(String) {
  school.students
  |> list.filter(fn(s) { s.grade == desired_grade })
  |> list.map(fn(s) { s.name })
}
