import '../../models/menu.model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class MenuService {
  static Future<List<MenuGroup>> getMenuGroups() async {
    try {
      final response = await ApiClient.get(ApiEndpoints.menuGroups);
      if (response != null && response is List) {
        return response.map((e) => MenuGroup.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load menu groups: $e');
    }
  }

  static Future<List<MenuItem>> getMenuItems() async {
    try {
      final response = await ApiClient.get(ApiEndpoints.menuItems);
      if (response != null && response is List) {
        return response.map((e) => MenuItem.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load menu items: $e');
    }
  }
}
