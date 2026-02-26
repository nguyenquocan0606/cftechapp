import 'package:flutter/material.dart';
import '../models/shift.model.dart';

class AppState extends ChangeNotifier {
  Shift? _currentShift;
  bool _isLoading = true;
  String? _error;

  Shift? get currentShift => _currentShift;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setShift(Shift shift) {
    _currentShift = shift;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
