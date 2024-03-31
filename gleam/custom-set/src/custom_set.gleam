import gleam/dict.{type Dict}
import gleam/list

pub opaque type Set(t) {
  Set(dict: Dict(t, Nil))
}

pub fn new(members: List(t)) -> Set(t) {
  Set(
    members
    |> list.map(fn(m) { #(m, Nil) })
    |> dict.from_list,
  )
}

pub fn is_empty(set: Set(t)) -> Bool {
  dict.size(set.dict) == 0
}

pub fn contains(in set: Set(t), this member: t) -> Bool {
  dict.has_key(set.dict, member)
}

pub fn is_subset(first: Set(t), of second: Set(t)) -> Bool {
  first.dict
  |> dict.filter(fn(member, _) { dict.has_key(second.dict, member) })
  == first.dict
}

pub fn disjoint(first: Set(t), second: Set(t)) -> Bool {
  first.dict
  |> dict.filter(fn(member, _) { dict.has_key(second.dict, member) })
  |> dict.size()
  == 0
}

pub fn is_equal(first: Set(t), to second: Set(t)) -> Bool {
  first.dict == second.dict
}

pub fn add(to set: Set(t), this member: t) -> Set(t) {
  Set(dict.insert(set.dict, member, Nil))
}

pub fn intersection(of first: Set(t), and second: Set(t)) -> Set(t) {
  Set(
    dict.filter(first.dict, fn(member, _) { dict.has_key(second.dict, member) }),
  )
}

pub fn difference(between first: Set(t), and second: Set(t)) -> Set(t) {
  Set(dict.drop(first.dict, dict.keys(second.dict)))
}

pub fn union(of first: Set(t), and second: Set(t)) -> Set(t) {
  Set(dict.merge(first.dict, second.dict))
}
