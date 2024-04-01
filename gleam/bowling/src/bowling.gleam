import gleam/list

pub opaque type Frame {
  NotLast(state: NotLastState)
  Last(state: LastState)
  Pending(state: PendingState)
}

type NotLastState {
  Open(roll1: Int, roll2: Int)
  Spare(roll1: Int, roll2: Int)
  Strike
}

type LastState {
  LastOpen(roll1: Int, roll2: Int)
  LastSpare(roll1: Int, roll2: Int, bonus: Int)
  LastStrike(bonus1: Int, bonus2: Int)
}

type PendingState {
  PendingNotLast(roll1: Int)
  PendingLast(roll1: Int)
  PendingLastSpare(roll1: Int, roll2: Int)
  PendingLastStrike
  PendingLastStrike2(bonus1: Int)
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
  case is_game_over(game), is_valid_knocked_pins(game, knocked_pins) {
    True, _ -> Error(GameComplete)
    False, False -> Error(InvalidPinCount)
    False, True -> Ok(do_roll(game, knocked_pins))
  }
}

fn do_roll(game: Game, knocked_pins: Int) -> Game {
  case game.frames {
    // First roll of the game
    [] ->
      case knocked_pins == 10 {
        True -> Game(frames: [NotLast(state: Strike)])

        False ->
          Game(frames: [Pending(state: PendingNotLast(roll1: knocked_pins))])
      }

    // First roll of frame
    [NotLast(state: _), ..] as rest ->
      case list.length(rest), knocked_pins == 10 {
        9, True -> Game(frames: [Pending(state: PendingLastStrike), ..rest])

        9, False ->
          Game(frames: [
            Pending(state: PendingLast(roll1: knocked_pins)),
            ..rest
          ])

        _, True -> Game(frames: [NotLast(state: Strike), ..rest])

        _, False ->
          Game(frames: [
            Pending(state: PendingNotLast(roll1: knocked_pins)),
            ..rest
          ])
      }

    // Second roll of frame
    [Pending(state: PendingNotLast(roll1: roll1)), ..rest] ->
      case roll1 + knocked_pins == 10 {
        True ->
          Game(frames: [
            NotLast(state: Spare(roll1: roll1, roll2: knocked_pins)),
            ..rest
          ])

        False ->
          Game(frames: [
            NotLast(state: Open(roll1: roll1, roll2: knocked_pins)),
            ..rest
          ])
      }

    // Second roll of last frame
    [Pending(state: PendingLast(roll1: roll1)), ..rest] ->
      case roll1 + knocked_pins == 10 {
        True ->
          Game(frames: [
            Pending(state: PendingLastSpare(roll1: roll1, roll2: knocked_pins)),
            ..rest
          ])
        False ->
          Game(frames: [
            Last(state: LastOpen(roll1: roll1, roll2: knocked_pins)),
            ..rest
          ])
      }

    // Bonus roll after last spare
    [Pending(state: PendingLastSpare(roll1: roll1, roll2: roll2)), ..rest] ->
      Game(frames: [
        Last(state: LastSpare(roll1: roll1, roll2: roll2, bonus: knocked_pins)),
        ..rest
      ])

    // First bonus of last strike
    [Pending(state: PendingLastStrike), ..rest] ->
      Game(frames: [
        Pending(state: PendingLastStrike2(bonus1: knocked_pins)),
        ..rest
      ])

    // Second bonus of last strike
    [Pending(state: PendingLastStrike2(bonus1: bonus1)), ..rest] ->
      Game(frames: [
        Last(state: LastStrike(bonus1: bonus1, bonus2: knocked_pins)),
        ..rest
      ])

    // This function should never be called on a finished game
    [Last(state: _), ..] -> panic
  }
}

fn is_game_over(game: Game) -> Bool {
  case game.frames {
    [Last(state: _), ..] -> True
    _ -> False
  }
}

fn is_valid_knocked_pins(game: Game, knocked_pins: Int) -> Bool {
  case 0 <= knocked_pins && knocked_pins <= 10 {
    False -> False
    True ->
      case game.frames {
        [Pending(state: PendingNotLast(roll1: roll)), ..]
          | [Pending(state: PendingLast(roll1: roll)), ..]
          | [Pending(state: PendingLastStrike2(bonus1: roll)), ..]
          if roll != 10
        -> roll + knocked_pins <= 10
        _ -> True
      }
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  case is_game_over(game) {
    False -> Error(GameNotComplete)
    True -> Ok(do_score(game))
  }
}

type Acc {
  Acc(score: Int, next_two_rolls: #(Int, Int))
}

fn do_score(game: Game) -> Int {
  list.fold(
    game.frames,
    Acc(score: 0, next_two_rolls: #(0, 0)),
    score_for_frame,
  ).score
}

fn score_for_frame(acc: Acc, frame: Frame) -> Acc {
  case frame {
    Last(state: LastOpen(roll1: roll1, roll2: roll2)) ->
      Acc(score: roll1 + roll2, next_two_rolls: #(roll1, roll2))

    Last(state: LastSpare(roll1: roll1, roll2: roll2, bonus: bonus)) ->
      Acc(score: roll1 + roll2 + bonus, next_two_rolls: #(roll1, roll2))

    Last(state: LastStrike(bonus1: bonus1, bonus2: bonus2)) ->
      Acc(score: 10 + bonus1 + bonus2, next_two_rolls: #(10, bonus1))

    NotLast(state: Open(roll1: roll1, roll2: roll2)) ->
      Acc(score: acc.score + roll1 + roll2, next_two_rolls: #(roll1, roll2))

    NotLast(state: Spare(roll1: roll1, roll2: roll2)) ->
      Acc(score: acc.score + 10 + acc.next_two_rolls.0, next_two_rolls: #(
        roll1,
        roll2,
      ))

    NotLast(state: Strike) ->
      Acc(
        score: acc.score + 10 + acc.next_two_rolls.0 + acc.next_two_rolls.1,
        next_two_rolls: #(10, acc.next_two_rolls.0),
      )

    // This function should never be used on an unfinished game
    Pending(state: _) -> panic
  }
}
