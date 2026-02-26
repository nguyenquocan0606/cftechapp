import 'package:flutter/material.dart';
import '../models/menu.model.dart';
import '../models/order.model.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  String note;

  CartItem({required this.menuItem, this.quantity = 1, this.note = ''});

  int get totalPrice => menuItem.price * quantity;

  OrderItemRequest toOrderRequest() {
    return OrderItemRequest(
      menuItemId: menuItem.id,
      quantity: quantity,
      unitPrice: menuItem.price,
      totalPrice: totalPrice,
      note: note,
    );
  }
}

class CartState extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(MenuItem item, {int quantity = 1, String note = ''}) {
    // Check if item exists with same note
    final existingIndex = _items.indexWhere(
      (i) => i.menuItem.id == item.id && i.note == note,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(menuItem: item, quantity: quantity, note: note));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      _items.remove(item);
    } else {
      item.quantity = newQuantity;
    }
    notifyListeners();
  }

  void updateNote(CartItem item, String newNote) {
    item.note = newNote;
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
