import 'package:flutter/material.dart';
import '../models/table.model.dart';
import '../services/table.service.dart';
import 'order_screen.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  Map<String, List<TableModel>> _groupedTables = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    setState(() => _isLoading = true);
    try {
      final tables = await TableService.getTables();

      final Map<String, List<TableModel>> grouped = {};
      for (var t in tables) {
        if (!grouped.containsKey(t.zone)) {
          grouped[t.zone] = [];
        }
        grouped[t.zone]!.add(t);
      }

      setState(() {
        _groupedTables = grouped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading tables: $e')));
      }
    }
  }

  void _onTableSelected(TableModel table) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderScreen(table: table)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Bàn'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _groupedTables.keys.length,
              itemBuilder: (context, index) {
                final zone = _groupedTables.keys.elementAt(index);
                final zoneTables = _groupedTables[zone]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        zone,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: zoneTables.length,
                      itemBuilder: (context, gridIndex) {
                        final table = zoneTables[gridIndex];
                        return InkWell(
                          onTap: () => _onTableSelected(table),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  table.zone == "Mang về"
                                      ? Icons.shopping_bag
                                      : Icons.table_restaurant,
                                  size: 32,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  table.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
    );
  }
}
