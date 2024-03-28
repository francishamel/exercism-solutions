import gleam/option.{None, type Option, Some}
import gleam/string

const sentence = "One for you, one for me."

pub fn two_fer(name: Option(String)) -> String {
  case name {
    Some(name) -> string.replace(sentence, each: "you", with: name)
    None -> sentence
  }
}
