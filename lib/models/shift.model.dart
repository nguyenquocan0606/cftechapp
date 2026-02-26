class Shift {
  final int id;
  final int staffId;
  final String shiftType;

  Shift({required this.id, required this.staffId, required this.shiftType});

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      staffId: json['staff_id'] is int
          ? json['staff_id']
          : int.parse(json['staff_id'].toString()),
      shiftType: json['shift_type'] ?? '',
    );
  }
}
