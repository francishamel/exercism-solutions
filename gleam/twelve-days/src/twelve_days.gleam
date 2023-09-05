import gleam/list
import gleam/string
import gleam/string_builder as sb

pub fn verse(number: Int) -> String {
  sb.new()
  |> sb.append("On the ")
  |> sb.append(number_to_day(number))
  |> sb.append(" day of Christmas my true love gave to me: ")
  |> sb.append(number_to_presents(number))
  |> sb.append(".")
  |> sb.to_string
}

fn number_to_day(number: Int) -> String {
  case number {
    1 -> "first"
    2 -> "second"
    3 -> "third"
    4 -> "fourth"
    5 -> "fifth"
    6 -> "sixth"
    7 -> "seventh"
    8 -> "eighth"
    9 -> "ninth"
    10 -> "tenth"
    11 -> "eleventh"
    12 -> "twelfth"
  }
}

fn number_to_presents(number: Int) -> String {
  case number {
    1 -> "a Partridge in a Pear Tree"
    _ ->
      list.range(1, number)
      |> list.reverse
      |> list.map(day_to_present)
      |> string.join(", ")
  }
}

fn day_to_present(day: Int) -> String {
  case day {
    1 -> "and a Partridge in a Pear Tree"
    2 -> "two Turtle Doves"
    3 -> "three French Hens"
    4 -> "four Calling Birds"
    5 -> "five Gold Rings"
    6 -> "six Geese-a-Laying"
    7 -> "seven Swans-a-Swimming"
    8 -> "eight Maids-a-Milking"
    9 -> "nine Ladies Dancing"
    10 -> "ten Lords-a-Leaping"
    11 -> "eleven Pipers Piping"
    12 -> "twelve Drummers Drumming"
  }
}

pub fn lyrics(from starting_verse: Int, to ending_verse: Int) -> String {
  list.range(starting_verse, ending_verse)
  |> list.map(verse)
  |> string.join("\n")
}
