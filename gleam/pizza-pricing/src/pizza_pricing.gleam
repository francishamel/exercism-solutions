import gleam/list

pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  calculate_pizza_price(pizza, 0)
}

fn calculate_pizza_price(pizza: Pizza, acc: Int) -> Int {
  case pizza {
    Margherita -> acc + 7
    Caprese -> acc + 9
    Formaggio -> acc + 10
    ExtraSauce(pizza) -> calculate_pizza_price(pizza, acc + 1)
    ExtraToppings(pizza) -> calculate_pizza_price(pizza, acc + 2)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  case list.length(order) {
    1 -> calculate_order_price(order, 3)
    2 -> calculate_order_price(order, 2)
    _ -> calculate_order_price(order, 0)
  }
}

fn calculate_order_price(order: List(Pizza), acc: Int) -> Int {
  case order {
    [] -> acc
    [pizza, ..rest] -> calculate_order_price(rest, acc + pizza_price(pizza))
  }
}
