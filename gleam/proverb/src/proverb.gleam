import gleam/list
import gleam/string

pub fn recite(inputs: List(String)) -> String {
  case inputs {
    [] -> ""
    [head, ..] ->
      inputs
      |> list.window_by_2
      |> list.map(line)
      |> list.append([last_line(head)])
      |> string.join("\n")
  }
}

fn line(objects: #(String, String)) -> String {
  "For want of a " <> objects.0 <> " the " <> objects.1 <> " was lost."
}

fn last_line(object: String) -> String {
  "And all for the want of a " <> object <> "."
}
