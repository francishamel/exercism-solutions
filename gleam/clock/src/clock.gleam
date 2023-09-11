import gleam/int
import gleam/string
import gleam/string_builder as sb

pub type Clock {
  Clock(hour: Int, minute: Int)
}

pub fn create(hour hour: Int, minute minute: Int) -> Clock {
  Clock(hour: 0, minute: 0)
  |> add(minutes: hour * 60)
  |> add(minutes: minute)
}

pub fn add(clock: Clock, minutes minutes: Int) -> Clock {
  let assert Ok(minutes_hour) = int.floor_divide(clock.minute + minutes, 60)
  let assert Ok(hour) = int.modulo(clock.hour + minutes_hour, 24)
  let assert Ok(minute) = int.modulo(clock.minute + minutes, 60)

  Clock(hour: hour, minute: minute)
}

pub fn subtract(clock: Clock, minutes minutes: Int) -> Clock {
  add(clock, minutes: -minutes)
}

pub fn display(clock: Clock) -> String {
  sb.new()
  |> sb.append(string.pad_left(int.to_string(clock.hour), 2, "0"))
  |> sb.append(":")
  |> sb.append(string.pad_left(int.to_string(clock.minute), 2, "0"))
  |> sb.to_string
}
