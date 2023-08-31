pub fn score(x: Float, y: Float) -> Int {
  case x *. x +. y *. y {
    x if x <=. 1.0 -> 10
    x if x <=. 25.0 -> 5
    x if x <=. 100.0 -> 1
    _ -> 0
  }
}
