import gleam/string

pub type Robot {
  Robot(direction: Direction, position: Position)
}

pub type Direction {
  North
  East
  South
  West
}

type TurnDirection {
  Clockwise
  AntiClockwise
}

pub type Position {
  Position(x: Int, y: Int)
}

pub fn create(direction: Direction, position: Position) -> Robot {
  Robot(direction: direction, position: position)
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  do_move(direction, position, string.to_graphemes(instructions))
}

fn do_move(
  direction: Direction,
  position: Position,
  instructions: List(String),
) -> Robot {
  case instructions {
    [] -> create(direction, position)
    ["A", ..rest] -> do_move(direction, advance(position, direction), rest)
    ["L", ..rest] -> do_move(turn(AntiClockwise, direction), position, rest)
    [_, ..rest] -> do_move(turn(Clockwise, direction), position, rest)
  }
}

fn advance(position: Position, direction: Direction) -> Position {
  case direction {
    North -> Position(x: position.x, y: position.y + 1)
    West -> Position(x: position.x - 1, y: position.y)
    South -> Position(x: position.x, y: position.y - 1)
    East -> Position(x: position.x + 1, y: position.y)
  }
}

fn turn(turn_direction: TurnDirection, direction: Direction) -> Direction {
  case turn_direction, direction {
    AntiClockwise, North -> West
    AntiClockwise, West -> South
    AntiClockwise, South -> East
    AntiClockwise, East -> North
    Clockwise, North -> East
    Clockwise, West -> North
    Clockwise, South -> West
    Clockwise, East -> South
  }
}
