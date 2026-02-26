import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/auth.service.dart';
import 'table_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeShift();
  }

  Future<void> _initializeShift() async {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      final shift = await AuthService.getOrCreateCurrentShift();
      appState.setShift(shift);
      // Navigate to TableScreen when done
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TableScreen()),
        );
      }
    } catch (e) {
      appState.setError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: Center(
        child: appState.error != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to init shift:\n${appState.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      appState.setLoading(true);
                      _initializeShift();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing Workspace...'),
                ],
              ),
      ),
    );
  }
}
