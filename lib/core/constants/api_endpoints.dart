class ApiEndpoints {
  static const String baseUrl = 'https://cftech.quocan.click';

  // Shifts
  static const String currentShift = '/api/shifts/current';
  static const String shifts = '/api/shifts/';

  // Orders
  static const String orders = '/api/v1/orders';

  // Menu
  static const String menuGroups = '/api/menu-groups/';
  static const String menuItems = '/api/menu-items/?limit=1000';

  // Images
  static String imageUrl(String code) => '$baseUrl/image/images/$code.png';
}
