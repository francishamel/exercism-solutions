import gleam/int
import gleam/list
import gleam/order.{Eq, Gt, Lt}

pub type Tree {
  Nil
  Node(data: Int, left: Tree, right: Tree)
}

pub fn to_tree(data: List(Int)) -> Tree {
  list.fold(over: data, from: Nil, with: insert)
}

fn insert(tree: Tree, element: Int) -> Tree {
  case tree {
    Nil -> Node(data: element, left: Nil, right: Nil)
    Node(data: data, left: left, right: right) ->
      case int.compare(element, data) {
        Lt | Eq -> Node(data: data, left: insert(left, element), right: right)
        Gt -> Node(data: data, left: left, right: insert(right, element))
      }
  }
}

pub fn sorted_data(data: List(Int)) -> List(Int) {
  data
  |> to_tree
  |> inorder_traversal
}

fn inorder_traversal(tree: Tree) -> List(Int) {
  case tree {
    Nil -> []
    Node(data: data, left: left, right: right) ->
      list.concat([inorder_traversal(left), [data], inorder_traversal(right)])
  }
}
