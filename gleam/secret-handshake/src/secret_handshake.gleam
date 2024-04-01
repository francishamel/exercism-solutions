import gleam/int
import gleam/list

pub type Command {
  Wink
  DoubleBlink
  CloseYourEyes
  Jump
}

pub fn commands(encoded_message: Int) -> List(Command) {
  [
    #(0b1, list.prepend(_, Wink)),
    #(0b10, list.prepend(_, DoubleBlink)),
    #(0b100, list.prepend(_, CloseYourEyes)),
    #(0b1000, list.prepend(_, Jump)),
    #(0b10000, list.reverse),
  ]
  |> list.fold([], fn(acc, mask_and_command) {
    let #(mask, command) = mask_and_command
    case int.bitwise_and(encoded_message, mask) {
      0 -> acc
      _ -> command(acc)
    }
  })
  |> list.reverse
}
