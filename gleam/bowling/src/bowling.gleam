import gleam/list

pub opaque type Frame {
  Frame(rolls: List(Int), bonus: List(Int))
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

pub fn roll(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  case is_game_over(game), is_valid_number_of_knocked_pins(game, knocked_pins) {
    True, _ -> Error(GameComplete)
    False, False -> Error(InvalidPinCount)
    False, True -> Ok(do_roll(game, knocked_pins))
  }
}

fn is_valid_number_of_knocked_pins(game: Game, knocked_pins: Int) -> Bool {
  case 0 <= knocked_pins && knocked_pins <= 10 {
    False -> False
    True ->
      case list.length(game.frames), game.frames {
        // Last frame is a strike + first bonus roll is not a strike
        10, [Frame(rolls: [10], bonus: [bonus_roll]), ..] if bonus_roll != 10 ->
          bonus_roll + knocked_pins <= 10
        // Frame is not a strike
        _, [Frame(rolls: [roll], bonus: _), ..] if roll != 10 ->
          roll + knocked_pins <= 10
        _, _ -> True
      }
  }
}

fn do_roll(game: Game, knocked_pins: Int) -> Game {
  case list.length(game.frames), game.frames {
    // When last frame is a strike, append to bonus
    10, [Frame(rolls: [10], bonus: bonus), ..rest] ->
      Game(frames: [Frame(rolls: [10], bonus: [knocked_pins, ..bonus]), ..rest])

    // When last frame is a spare, append to bonus
    10, [Frame(rolls: [roll1, roll2], bonus: []), ..rest] ->
      Game(frames: [Frame(rolls: [roll1, roll2], bonus: [knocked_pins]), ..rest])

    // New frame
    _, [Frame(rolls: [_, _], bonus: []), ..] ->
      Game(frames: [Frame(rolls: [knocked_pins], bonus: []), ..game.frames])

    _, [Frame(rolls: [10], bonus: []), ..] ->
      Game(frames: [Frame(rolls: [knocked_pins], bonus: []), ..game.frames])

    // Second roll for current frame
    _, [Frame(rolls: [roll], bonus: []), ..rest] ->
      Game(frames: [Frame(rolls: [knocked_pins, roll], bonus: []), ..rest])

    // Special case for 1st roll of the game
    _, _ -> Game(frames: [Frame(rolls: [knocked_pins], bonus: [])])
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  case is_game_over(game) {
    True -> Ok(0)
    False -> Error(GameNotComplete)
  }
}

fn is_game_over(game: Game) -> Bool {
  case list.length(game.frames), game.frames {
    // Strike for last frame + 2 bonus rolls
    10, [Frame(rolls: [10], bonus: [_, _]), ..] -> True
    // Spare for last frame + 1 bonus roll
    10, [Frame(rolls: [_, _], bonus: [_]), ..] -> True
    // No spare for last frame + 0 bonus roll
    10, [Frame(rolls: [roll1, roll2], bonus: []), ..] -> roll1 + roll2 < 10
    _, _ -> False
  }
}
