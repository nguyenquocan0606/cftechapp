import '../../models/shift.model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class AuthService {
  // Config default for internal app
  static const int defaultStaffId = 1;

  static Future<Shift> getOrCreateCurrentShift() async {
    try {
      // 1. Try to get current shift
      final response = await ApiClient.get(ApiEndpoints.currentShift);
      if (response != null &&
          response is Map<String, dynamic> &&
          response.isNotEmpty) {
        // Assume response contains shift data
        // Nếu API trả về trực tiếp object Shift thì parse, nếu có format data thì sửa lại phù hợp
        return Shift.fromJson(response);
      }
    } catch (e) {
      // Ignored initially to try opening a new shift if GET fails for "not found"
      print('Failed to get current shift: $e. Creating new one...');
    }

    // 2. If null or error, create new shift
    return openNewShift();
  }

  static Future<Shift> openNewShift() async {
    try {
      final payload = {
        "staff_id": defaultStaffId,
        "shift_type": "Sáng",
        "initial_cash": 0,
        "staff1_start_order_number": 1,
        "note": "Auto-opened from Internal App",
      };
      final response = await ApiClient.post(ApiEndpoints.shifts, body: payload);
      if (response != null && response is Map<String, dynamic>) {
        return Shift.fromJson(response);
      }
      throw Exception('Invalid response when creating shift');
    } catch (e) {
      throw Exception('Failed to open shift: $e');
    }
  }
}
