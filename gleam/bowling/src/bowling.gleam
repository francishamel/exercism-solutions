import gleam/bool
import gleam/list

pub opaque type Frame {
  BeforeLast(state: BeforeLastState)
  Last(state: LastState)
  Pending(state: PendingState)
}

type BeforeLastState {
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
  PendingBeforeLast(roll1: Int)
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
  use <- bool.guard(
    is_invalid_knocked_pins(game, knocked_pins),
    Error(InvalidPinCount),
  )

  case game.frames {
    [Last(..), ..] -> Error(GameComplete)
    [] | [BeforeLast(..), ..] ->
      Ok(Game([new_frame(game.frames, knocked_pins), ..game.frames]))
    [Pending(state), ..rest] ->
      Ok(Game([update_pending_frame(state, knocked_pins), ..rest]))
  }
}

fn new_frame(rest: List(Frame), knocked_pins: Int) -> Frame {
  case list.length(rest), knocked_pins == 10 {
    9, True -> Pending(PendingLastStrike)
    9, False -> Pending(PendingLast(knocked_pins))
    _, True -> BeforeLast(Strike)
    _, False -> Pending(PendingBeforeLast(knocked_pins))
  }
}

fn update_pending_frame(state: PendingState, knocked_pins: Int) -> Frame {
  case state {
    PendingBeforeLast(roll1) ->
      case roll1 + knocked_pins == 10 {
        True -> BeforeLast(Spare(roll1, knocked_pins))
        False -> BeforeLast(Open(roll1, knocked_pins))
      }

    PendingLast(roll1) ->
      case roll1 + knocked_pins == 10 {
        True -> Pending(PendingLastSpare(roll1, knocked_pins))
        False -> Last(LastOpen(roll1, knocked_pins))
      }

    PendingLastSpare(roll1, roll2) ->
      Last(LastSpare(roll1, roll2, knocked_pins))

    PendingLastStrike -> Pending(PendingLastStrike2(knocked_pins))

    PendingLastStrike2(bonus1) -> Last(LastStrike(bonus1, knocked_pins))
  }
}

fn is_invalid_knocked_pins(game: Game, knocked_pins: Int) -> Bool {
  case 0 <= knocked_pins && knocked_pins <= 10 {
    False -> True
    True ->
      case game.frames {
        [Pending(PendingBeforeLast(roll)), ..]
          | [Pending(PendingLast(roll)), ..]
          | [Pending(PendingLastStrike2(roll)), ..]
          if roll != 10
        -> roll + knocked_pins > 10
        _ -> False
      }
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  case game.frames {
    [Last(..), ..] -> Ok(do_score(game.frames, 0, 0, 0))
    _ -> Error(GameNotComplete)
  }
}

fn do_score(
  frames: List(Frame),
  next_roll1: Int,
  next_roll2: Int,
  score: Int,
) -> Int {
  case frames {
    [] -> score
    [frame, ..rest] ->
      case frame {
        Last(LastStrike(bonus1, bonus2)) ->
          do_score(rest, 10, bonus1, score + 10 + bonus1 + bonus2)

        Last(LastSpare(roll1, roll2, bonus)) ->
          do_score(rest, roll1, roll2, score + roll1 + roll2 + bonus)

        BeforeLast(Open(roll1, roll2)) | Last(LastOpen(roll1, roll2)) ->
          do_score(rest, roll1, roll2, score + roll1 + roll2)

        BeforeLast(Spare(roll1, roll2)) ->
          do_score(rest, roll1, roll2, score + roll1 + roll2 + next_roll1)

        BeforeLast(Strike) ->
          do_score(rest, 10, next_roll1, score + 10 + next_roll1 + next_roll2)

        // We should never reach this state since we only calculate scores for terminated games
        Pending(..) -> panic
      }
  }
}
