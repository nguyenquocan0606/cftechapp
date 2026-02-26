class OrderItemRequest {
  final int menuItemId;
  final int quantity;
  final int unitPrice;
  final int totalPrice;
  final String note;

  OrderItemRequest({
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.note = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'note': note,
    };
  }
}

class CreateOrderRequest {
  final int tableId;
  final int staffId;
  final int shiftId;
  final String status;
  final int totalAmount;
  final String paymentStatus;
  final String note;
  final List<OrderItemRequest> items;

  CreateOrderRequest({
    required this.tableId,
    required this.staffId,
    required this.shiftId,
    this.status = 'pending',
    required this.totalAmount,
    this.paymentStatus = 'unpaid',
    this.note = '',
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'table_id': tableId,
      'staff_id': staffId,
      'shift_id': shiftId,
      'status': status,
      'total_amount': totalAmount,
      'payment_status': paymentStatus,
      'note': note,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
