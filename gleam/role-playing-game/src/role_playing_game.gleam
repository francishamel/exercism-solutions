import gleam/int
import gleam/option.{None, type Option, Some}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  option.unwrap(player.name, "Mighty")
  case player.name {
    Some(name) -> name
    None -> "Mighty Magician"
  }
}

pub fn revive(player: Player) -> Option(Player) {
  case player.health == 0 {
    True ->
      case player.level >= 10 {
        True -> Some(Player(..player, health: 100, mana: Some(100)))
        False -> Some(Player(..player, health: 100))
      }
    _ -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana {
    Some(mana) if mana >= cost -> #(
      Player(..player, mana: Some(mana - cost)),
      cost * 2,
    )
    Some(_mana) -> #(player, 0)
    None -> #(Player(..player, health: int.max(player.health - cost, 0)), 0)
  }
}
