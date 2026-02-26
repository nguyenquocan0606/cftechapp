import '../../models/order.model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class OrderService {
  static Future<bool> createOrder(CreateOrderRequest request) async {
    try {
      await ApiClient.post(ApiEndpoints.orders, body: request.toJson());
      // Có thể log response nếu cần: print('Order created: $response');
      return true;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}
