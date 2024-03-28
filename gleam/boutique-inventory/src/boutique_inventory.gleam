import gleam/iterator.{type Iterator}

pub type Item {
  Item(name: String, price: Int, quantity: Int)
}

pub fn item_names(items: Iterator(Item)) -> Iterator(String) {
  iterator.map(over: items, with: fn(i: Item) -> String { i.name })
}

pub fn cheap(items: Iterator(Item)) -> Iterator(Item) {
  iterator.filter(items, keeping: fn(i: Item) -> Bool { i.price < 30 })
}

pub fn out_of_stock(items: Iterator(Item)) -> Iterator(Item) {
  iterator.filter(items, keeping: fn(i: Item) -> Bool { i.quantity == 0 })
}

pub fn total_stock(items: Iterator(Item)) -> Int {
  iterator.fold(
    over: items,
    from: 0,
    with: fn(acc: Int, i: Item) -> Int { acc + i.quantity },
  )
}
