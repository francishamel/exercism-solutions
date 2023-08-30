pub fn equilateral(a: Float, b: Float, c: Float) -> Bool {
  is_valid_length(a, b, c) && respects_triangle_inequality(a, b, c) && a == b && a == c
}

pub fn isosceles(a: Float, b: Float, c: Float) -> Bool {
  is_valid_length(a, b, c) && respects_triangle_inequality(a, b, c) && {
    a == b || a == c || b == c
  }
}

pub fn scalene(a: Float, b: Float, c: Float) -> Bool {
  is_valid_length(a, b, c) && respects_triangle_inequality(a, b, c) && a != b && a != c && b != c
}

fn respects_triangle_inequality(a: Float, b: Float, c: Float) -> Bool {
  a +. b >=. c && b +. c >=. a && a +. c >=. b
}

fn is_valid_length(a: Float, b: Float, c: Float) -> Bool {
  a >. 0.0 && b >. 0.0 && c >. 0.0
}
