import gleam/string

pub fn first_letter(name: String) -> String {
  name
  |> string.trim()
  |> string.slice(at_index: 0, length: 1)
}

pub fn initial(name: String) {
  name
  |> first_letter()
  |> string.uppercase()
  |> string.append(".")
}

pub fn initials(full_name: String) {
  case string.split(full_name, " ") {
    [first_name, last_name] -> initial(first_name) <> " " <> initial(last_name)
  }
}

pub fn pair(full_name1: String, full_name2: String) {
  "
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     {{1}}  +  {{2}}     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
"
  |> string.replace(each: "{{1}}", with: initials(full_name1))
  |> string.replace(each: "{{2}}", with: initials(full_name2))
}
