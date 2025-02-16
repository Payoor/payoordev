import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_googleapiroutes.dart';

class GooglePlaces with ChangeNotifier {
  List<dynamic> _predictions = [];
  bool _isLoading = false;
  String _address = "";

  bool get isLoading => _isLoading;
  String get address => _address;
  List<dynamic> get predictions => _predictions;

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      _predictions = [];
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final response = await GoogleApiRoutes.searchPlaces(query);
      _predictions = response?.data?["placesResponse"] ?? [];
    } catch (error) {
      //print('Error searching places: $error');
      _predictions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAddressFromCoordinates(
      String address, num? lat, num? lng) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (lat == null || lng == null) {
        throw Exception('Latitude or longitude is missing');
      }

      final response = await GoogleApiRoutes.getAddressFromCoordinates(
        address,
        lat,
        lng,
      );

      _address = response?.data?["address"] ?? '$lat, $lng';
      _predictions = response?.data?["filteredResults"] ?? [];
    } catch (error) {
      _address = '$lat, $lng';
      _predictions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearPredictions() {
    _predictions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
