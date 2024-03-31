import gleam/int
import gleam/list

pub opaque type Frame {
  Frame(rolls: List(Int))
  LastFrame(rolls: List(Int), bonus: List(Int))
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

fn is_game_over(game: Game) -> Bool {
  case game.frames {
    [LastFrame(rolls: [10], bonus: [_, _]), ..] -> True
    [LastFrame(rolls: [_, _], bonus: [_]), ..] -> True
    [LastFrame(rolls: [roll1, roll2], bonus: []), ..] -> roll1 + roll2 < 10
    _ -> False
  }
}

fn is_valid_number_of_knocked_pins(game: Game, knocked_pins: Int) -> Bool {
  case 0 <= knocked_pins && knocked_pins <= 10 {
    False -> False
    True ->
      case game.frames {
        [LastFrame(rolls: [10], bonus: [bonus_roll]), ..] if bonus_roll != 10 ->
          bonus_roll + knocked_pins <= 10
        [LastFrame(rolls: [roll], bonus: []), ..] if roll != 10 ->
          roll + knocked_pins <= 10
        [Frame(rolls: [roll]), ..] if roll != 10 -> roll + knocked_pins <= 10
        _ -> True
      }
  }
}

fn do_roll(game: Game, knocked_pins: Int) -> Game {
  case list.length(game.frames), game.frames {
    10, [LastFrame(rolls: [10], bonus: bonus), ..rest] ->
      Game(frames: [
        LastFrame(rolls: [10], bonus: [knocked_pins, ..bonus]),
        ..rest
      ])

    10, [LastFrame(rolls: [roll1, roll2], bonus: []), ..rest] ->
      Game(frames: [
        LastFrame(rolls: [roll1, roll2], bonus: [knocked_pins]),
        ..rest
      ])

    9, [Frame(rolls: [10]), ..] | 9, [Frame(rolls: [_, _]), ..] ->
      Game(frames: [LastFrame(rolls: [knocked_pins], bonus: []), ..game.frames])

    _, [Frame(rolls: [_, _]), ..] | _, [Frame(rolls: [10]), ..] ->
      Game(frames: [Frame(rolls: [knocked_pins]), ..game.frames])

    _, [Frame(rolls: [roll]), ..rest] ->
      Game(frames: [Frame(rolls: [knocked_pins, roll]), ..rest])

    _, [LastFrame(rolls: [roll], bonus: []), ..rest] ->
      Game(frames: [LastFrame(rolls: [knocked_pins, roll], bonus: []), ..rest])
    // 1st roll of the game
    0, [] -> Game(frames: [Frame(rolls: [knocked_pins])])

    // Impossible state
    _, _ -> panic
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  case is_game_over(game) {
    True -> Ok(do_score(game))
    False -> Error(GameNotComplete)
  }
}

fn do_score(game: Game) -> Int {
  let assert [LastFrame(rolls: rolls, bonus: bonus), ..rest] = game.frames
  let next_two_rolls = case rolls, bonus {
    [10], [_, bonus_roll] -> #(10, bonus_roll)
    [roll2, roll1], _ -> #(roll1, roll2)
    _, _ -> panic
  }

  let initial_score = int.sum(rolls) + int.sum(bonus)

  let #(score, _) =
    list.fold(
      over: rest,
      from: #(initial_score, next_two_rolls),
      with: calculate_frame,
    )
  score
}

type AccType =
  #(Int, #(Int, Int))

fn calculate_frame(acc: AccType, frame: Frame) -> AccType {
  let #(score, #(next_roll1, next_roll2)) = acc

  case frame.rolls {
    [10] -> #(score + 10 + next_roll1 + next_roll2, #(10, next_roll1))
    [roll2, roll1] ->
      case roll2 + roll1 == 10 {
        True -> #(score + 10 + next_roll1, #(roll1, roll2))
        False -> #(score + roll1 + roll2, #(roll1, roll2))
      }
    _ -> panic
  }
}
