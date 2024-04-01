import gleam/bool
import gleam/int

pub type Position {
  Position(row: Int, column: Int)
}

pub type Error {
  RowTooSmall
  RowTooLarge
  ColumnTooSmall
  ColumnTooLarge
}

pub fn create(queen: Position) -> Result(Nil, Error) {
  use <- bool.guard(queen.row < 0, Error(RowTooSmall))
  use <- bool.guard(queen.row > 7, Error(RowTooLarge))
  use <- bool.guard(queen.column < 0, Error(ColumnTooSmall))
  use <- bool.guard(queen.column > 7, Error(ColumnTooLarge))
  Ok(Nil)
}

pub fn can_attack(
  black_queen black_queen: Position,
  white_queen white_queen: Position,
) -> Bool {
  same_row(black_queen, white_queen)
  || same_column(black_queen, white_queen)
  || same_diagonal(black_queen, white_queen)
}

fn same_row(black_queen: Position, white_queen: Position) -> Bool {
  black_queen.row == white_queen.row
}

fn same_column(black_queen: Position, white_queen: Position) -> Bool {
  black_queen.column == white_queen.column
}

fn same_diagonal(black_queen: Position, white_queen: Position) -> Bool {
  int.absolute_value(black_queen.row - white_queen.row)
  == int.absolute_value(black_queen.column - white_queen.column)
}
