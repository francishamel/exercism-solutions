import gleam/queue.{type Queue}
import gleam/string

pub fn is_paired(value: String) -> Bool {
  do_is_paired(value, queue.new())
}

fn do_is_paired(value: String, stack: Queue(String)) -> Bool {
  case value, queue.pop_front(stack) {
    // Stack the opening brackets
    "[" <> rest, _ -> do_is_paired(rest, queue.push_front(stack, "["))
    "(" <> rest, _ -> do_is_paired(rest, queue.push_front(stack, "("))
    "{" <> rest, _ -> do_is_paired(rest, queue.push_front(stack, "{"))

    // Un-stack the opening brackets if they match the closing brackets
    "]" <> rest, Ok(#("[", stack)) -> do_is_paired(rest, stack)
    ")" <> rest, Ok(#("(", stack)) -> do_is_paired(rest, stack)
    "}" <> rest, Ok(#("{", stack)) -> do_is_paired(rest, stack)

    // Here, it means we didn't have the matching opening bracket in the stack
    "]" <> _rest, _ -> False
    ")" <> _rest, _ -> False
    "}" <> _rest, _ -> False

    // Here, it means we processed the value and the stack was empty
    "", Error(Nil) -> True

    // Here, we were missing some closing parantheses
    "", _ -> False

    // We ignore the value if it's not a bracket
    value, _ ->
      do_is_paired(string.slice(value, 1, string.length(value) - 1), stack)
  }
}
