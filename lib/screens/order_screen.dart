import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/table.model.dart';
import '../models/menu.model.dart';
import '../models/order.model.dart';
import '../providers/app_state.dart';
import '../providers/cart_state.dart';
import '../services/menu.service.dart';
import '../services/order.service.dart';
import '../core/constants/api_endpoints.dart';

class OrderScreen extends StatefulWidget {
  final TableModel table;

  const OrderScreen({super.key, required this.table});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<MenuGroup> _groups = [];
  List<MenuItem> _items = [];
  List<MenuItem> _filteredItems = [];
  bool _isLoading = true;
  int? _selectedGroupId;
  final TextEditingController _searchController = TextEditingController();

  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _loadMenu();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMenu() async {
    setState(() => _isLoading = true);
    try {
      final groups = await MenuService.getMenuGroups();
      final items = await MenuService.getMenuItems();
      setState(() {
        _groups = groups;
        _items = items;
        _filteredItems = items;
        _isLoading = false;
        if (_groups.isNotEmpty) {
          _selectedGroupId = _groups.first.id;
          _filterItems();
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tải menu: $e')));
      }
    }
  }

  void _onSearchChanged() {
    _filterItems();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        final matchesGroup =
            _selectedGroupId == null || item.menuGroupId == _selectedGroupId;
        final matchesSearch =
            item.title.toLowerCase().contains(query) ||
            item.code.toLowerCase().contains(query);
        return matchesGroup && matchesSearch;
      }).toList();
    });
  }

  void _showAddToCartDialog(MenuItem item) {
    int quantity = 1;
    String note = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(item.title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (quantity > 1) setDialogState(() => quantity--);
                        },
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setDialogState(() => quantity++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú (tùy chọn)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => note = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CartState>().addItem(
                      item,
                      quantity: quantity,
                      note: note,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm ${item.title} vào đơn'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text('Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<CartState>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Giỏ hàng trống'));
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Giỏ hàng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: cart.items.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final cartItem = cart.items[index];
                          return ListTile(
                            title: Text(cartItem.menuItem.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currencyFormat.format(
                                    cartItem.menuItem.price,
                                  ),
                                ),
                                if (cartItem.note.isNotEmpty)
                                  Text(
                                    'Ghi chú: ${cartItem.note}',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                InkWell(
                                  onTap: () {
                                    // Hiện popup sửa ghi chú nhanh trong giỏ hàng
                                    String tempNote = cartItem.note;
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Ghi chú món'),
                                        content: TextField(
                                          controller: TextEditingController(
                                            text: tempNote,
                                          ),
                                          onChanged: (val) => tempNote = val,
                                          decoration: const InputDecoration(
                                            hintText: 'Vd: ít đá, ít đường',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text('Huỷ'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              cart.updateNote(
                                                cartItem,
                                                tempNote,
                                              );
                                              Navigator.pop(ctx);
                                            },
                                            child: const Text('Lưu'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sửa ghi chú',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 20),
                                  onPressed: () => cart.updateQuantity(
                                    cartItem,
                                    cartItem.quantity - 1,
                                  ),
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  onPressed: () => cart.updateQuantity(
                                    cartItem,
                                    cartItem.quantity + 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tổng tiền:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _currencyFormat.format(cart.totalAmount),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => _createOrder(cart),
                              child: const Text(
                                'Tạo Order',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _createOrder(CartState cart) async {
    final appState = context.read<AppState>();
    if (appState.currentShift == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi: Không tìm thấy ca làm việc')),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final request = CreateOrderRequest(
        tableId: widget.table.id,
        staffId: appState.currentShift!.staffId,
        shiftId: appState.currentShift!.id,
        totalAmount: cart.totalAmount,
        paymentStatus: 'unpaid',
        note: '',
        items: cart.items.map((i) => i.toOrderRequest()).toList(),
      );

      print('=== CREATE ORDER PAYLOAD ===');
      print(jsonEncode(request.toJson()));

      final success = await OrderService.createOrder(request);
      if (mounted) {
        Navigator.pop(context); // Close loading
        if (success) {
          cart.clear(); // Clear cart
          Navigator.pop(context); // Close bottom sheet
          Navigator.pop(context); // Go back to Table grid
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Tạo order thành công')));
        }
      }
    } catch (e) {
      print('=== CREATE ORDER ERROR ===');
      print(e.toString());
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tạo order: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.table.name),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Consumer<AppState>(
                builder: (context, state, _) {
                  return Text(
                    state.currentShift != null
                        ? 'Ca: ${state.currentShift!.id}'
                        : '',
                    style: const TextStyle(fontSize: 14),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Thêm thanh Search
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm món (Tên hoặc mã)',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                // Nhóm món
                if (_groups.isNotEmpty)
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: _groups.length,
                      itemBuilder: (context, index) {
                        final group = _groups[index];
                        final isSelected = group.id == _selectedGroupId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(group.content),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedGroupId = group.id;
                                  _filterItems();
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                // Danh sách món
                Expanded(
                  child: _filteredItems.isEmpty
                      ? const Center(child: Text('Không tìm thấy món'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _showAddToCartDialog(item),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: CachedNetworkImage(
                                        imageUrl: ApiEndpoints.imageUrl(
                                          item.code,
                                        ),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.fastfood,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _currencyFormat.format(item.price),
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: Consumer<CartState>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: _showCartBottomSheet,
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              '${cart.totalQuantity} món - ${_currencyFormat.format(cart.totalAmount)}',
            ),
          );
        },
      ),
    );
  }
}
