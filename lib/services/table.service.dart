import '../models/table.model.dart';

class TableService {
  // Vì hiện tại Bàn không có state (tạo order xong thanh toán ngay), ta có thể
  // sinh ra một danh sách Bàn tĩnh hoặc lấy từ API tuỳ ý.
  // API lấy Trạng Thái Bàn lọc status active/pending không cần thiết nữa
  // Theo "hãy bắt đầu đi tuy nhiên tôi bổ sung là bàn sẽ không có trạng thái vì khi order xong thì mặc định là thanh toán luôn"

  static Future<List<TableModel>> getTables() async {
    // Fake network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      TableModel(id: 1, name: "Bàn 1", zone: "Bàn 1 - 5"),
      TableModel(id: 2, name: "Bàn 2", zone: "Bàn 1 - 5"),
      TableModel(id: 3, name: "Bàn 3", zone: "Bàn 1 - 5"),
      TableModel(id: 4, name: "Bàn 4", zone: "Bàn 1 - 5"),
      TableModel(id: 5, name: "Bàn 5", zone: "Bàn 1 - 5"),

      TableModel(id: 6, name: "Bàn 6", zone: "Bàn 6 - 14"),
      TableModel(id: 7, name: "Bàn 7", zone: "Bàn 6 - 14"),
      TableModel(id: 8, name: "Bàn 8", zone: "Bàn 6 - 14"),
      TableModel(id: 9, name: "Bàn 9", zone: "Bàn 6 - 14"),
      TableModel(id: 10, name: "Bàn 10", zone: "Bàn 6 - 14"),
      TableModel(id: 11, name: "Bàn 11", zone: "Bàn 6 - 14"),
      TableModel(id: 12, name: "Bàn 12", zone: "Bàn 6 - 14"),
      TableModel(id: 13, name: "Bàn 13", zone: "Bàn 6 - 14"),
      TableModel(id: 14, name: "Bàn 14", zone: "Bàn 6 - 14"),

      TableModel(id: 39, name: "15", zone: "Bàn 15 - 20"),
      TableModel(id: 40, name: "16", zone: "Bàn 15 - 20"),
      TableModel(id: 41, name: "17", zone: "Bàn 15 - 20"),
      TableModel(id: 42, name: "18", zone: "Bàn 15 - 20"),
      TableModel(id: 43, name: "19", zone: "Bàn 15 - 20"),
      TableModel(id: 44, name: "20", zone: "Bàn 15 - 20"),

      TableModel(id: 22, name: "T1", zone: "Bàn T1 - T8"),
      TableModel(id: 21, name: "T2", zone: "Bàn T1 - T8"),
      TableModel(id: 20, name: "T3", zone: "Bàn T1 - T8"),
      TableModel(id: 19, name: "T4", zone: "Bàn T1 - T8"),
      TableModel(id: 15, name: "T5", zone: "Bàn T1 - T8"),
      TableModel(id: 16, name: "T6", zone: "Bàn T1 - T8"),
      TableModel(id: 17, name: "T7", zone: "Bàn T1 - T8"),
      TableModel(id: 18, name: "T8", zone: "Bàn T1 - T8"),

      TableModel(id: 23, name: "N1", zone: "Bàn N1 - N6"),
      TableModel(id: 24, name: "N2", zone: "Bàn N1 - N6"),
      TableModel(id: 25, name: "N3", zone: "Bàn N1 - N6"),
      TableModel(id: 26, name: "N4", zone: "Bàn N1 - N6"),
      TableModel(id: 27, name: "N5", zone: "Bàn N1 - N6"),
      TableModel(id: 28, name: "N6", zone: "Bàn N1 - N6"),

      TableModel(id: 29, name: "B1", zone: "Bàn B1 - B10"),
      TableModel(id: 30, name: "B2", zone: "Bàn B1 - B10"),
      TableModel(id: 31, name: "B3", zone: "Bàn B1 - B10"),
      TableModel(id: 32, name: "B4", zone: "Bàn B1 - B10"),
      TableModel(id: 33, name: "B5", zone: "Bàn B1 - B10"),
      TableModel(id: 34, name: "B6", zone: "Bàn B1 - B10"),
      TableModel(id: 35, name: "B7", zone: "Bàn B1 - B10"),
      TableModel(id: 36, name: "B8", zone: "Bàn B1 - B10"),
      TableModel(id: 37, name: "B9", zone: "Bàn B1 - B10"),
      TableModel(id: 38, name: "B10", zone: "Bàn B1 - B10"),

      TableModel(id: 45, name: "Mang về", zone: "Mang về"),
    ];
  }
}
