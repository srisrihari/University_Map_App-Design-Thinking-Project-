import 'package:flutter/foundation.dart';
import '../models/location.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _service = LocationService();
  List<Location> _locations = [];
  bool _isLoading = false;
  String? _error;

  List<Location> get locations => _locations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLocations({String? type}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _locations = await _service.getLocations(type: type);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchLocations(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _locations = await _service.searchLocations(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
