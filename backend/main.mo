import Bool "mo:base/Bool";
import List "mo:base/List";
import Text "mo:base/Text";

import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor ShoppingList {
  // Define the structure for a shopping list item
  public type ShoppingListItem = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Stable variable to store the shopping list items
  stable var items : [ShoppingListItem] = [];
  stable var nextId : Nat = 0;

  // Add a new item to the shopping list
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem : ShoppingListItem = {
      id = id;
      text = text;
      completed = false;
    };
    items := Array.append(items, [newItem]);
    id
  };

  // Toggle the completion status of an item
  public func toggleItem(id: Nat) : async Bool {
    let index = Array.indexOf<ShoppingListItem>({ id = id; text = ""; completed = false }, items, func(a, b) { a.id == b.id });
    switch (index) {
      case null { false };
      case (?i) {
        let item = items[i];
        let updatedItem = {
          id = item.id;
          text = item.text;
          completed = not item.completed;
        };
        items := Array.tabulate(items.size(), func (j: Nat) : ShoppingListItem {
          if (j == i) { updatedItem } else { items[j] }
        });
        true
      };
    }
  };

  // Delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    let newItems = Array.filter<ShoppingListItem>(items, func(item) { item.id != id });
    if (newItems.size() < items.size()) {
      items := newItems;
      true
    } else {
      false
    }
  };

  // Get all items in the shopping list
  public query func getItems() : async [ShoppingListItem] {
    items
  };
}
