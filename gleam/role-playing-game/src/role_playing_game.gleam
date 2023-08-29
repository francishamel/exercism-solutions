import gleam/int
import gleam/option.{None, Option, Some}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    Some(name) -> name
    None -> "Mighty Magician"
  }
}

pub fn revive(player: Player) -> Option(Player) {
  case player {
    Player(health: h, level: l, ..) if h == 0 && l >= 10 ->
      Some(Player(..player, health: 100, mana: Some(100)))
    Player(health: h, ..) if h == 0 -> Some(Player(..player, health: 100))
    _ -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana {
    Some(mana) if mana >= cost -> #(
      Player(..player, mana: Some(mana - cost)),
      cost * 2,
    )
    None -> #(Player(..player, health: int.max(player.health - cost, 0)), 0)
    _ -> #(player, 0)
  }
}
