class TableModel {
  final int id;
  final String name;
  final String zone;

  TableModel({required this.id, required this.name, this.zone = ''});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? 'Bàn ${json['id']}',
    );
  }
}

class TableOrderStatus {
  final int tableId;
  final String status;
  final int orderId;
  final num totalAmount;
  final String timeIn;

  TableOrderStatus({
    required this.tableId,
    required this.status,
    required this.orderId,
    required this.totalAmount,
    required this.timeIn,
  });

  factory TableOrderStatus.fromJson(Map<String, dynamic> json) {
    return TableOrderStatus(
      tableId: json['table_id'] as int? ?? 0,
      status: json['status']?.toString() ?? '',
      orderId: json['id'] as int? ?? 0,
      totalAmount: json['total_amount'] as num? ?? 0,
      timeIn: json['time_in']?.toString() ?? '',
    );
  }
}
