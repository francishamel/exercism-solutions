pub type Approval {
  Yes
  No
  Maybe
}

pub type Cuisine {
  Korean
  Turkish
}

pub type Genre {
  Crime
  Horror
  Romance
  Thriller
}

pub type Activity {
  BoardGame
  Chill
  Movie(Genre)
  Restaurant(Cuisine)
  Walk(Int)
}

pub fn rate_activity(activity: Activity) -> Approval {
  case activity {
    BoardGame -> No
    Chill -> No
    Movie(m) ->
      case m {
        Romance -> Yes
        _ -> No
      }
    Restaurant(r) ->
      case r {
        Korean -> Yes
        Turkish -> Maybe
      }
    Walk(km) ->
      case km {
        i if i > 11 -> Yes
        i if i > 6 -> Maybe
        _ -> No
      }
  }
}
