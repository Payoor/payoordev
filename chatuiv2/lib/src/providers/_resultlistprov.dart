import 'package:flutter/material.dart';

class ResultListProvider extends ChangeNotifier {
  int _total = 0;
  int _totaldocs = 0; 
  List<dynamic> _results = [];
  List<String> _suggested_prompts = [];
  String _current_product_name = "";
  String _current_product_id = "";
  String _current_suggestion = "";
  bool _loading = false;
  String _aiquery = "";

  ResultListProvider({
    int total = 0,
    int totaldocs = 0, // Added to constructor
    List<dynamic> results = const [],
    List<String> suggested_prompts = const [],
    String aiquery = "",
  }) {
    _total = total;
    _totaldocs = totaldocs; // Initialize totaldocs
    _results = results;
    _suggested_prompts = suggested_prompts;
    _aiquery = aiquery;
  }

  int get total => _total;
  int get totaldocs => _totaldocs; // New getter
  List<dynamic> get results => _results;
  List<String> get suggested_prompts => _suggested_prompts;
  String get current_product_name => _current_product_name;
  String get current_product_id => _current_product_id;
  String get current_suggestion => _current_suggestion;
  bool get loading => _loading;
  String get aiquery => _aiquery;

  // Set totaldocs
  void setTotaldocs(int count) {
    _totaldocs = count;
    notifyListeners();
  }

  // Set aiquery
  void setAiquery(String query) {
    _aiquery = query;
    notifyListeners();
  }

  // Method to reset aiquery
  void resetAiquery() {
    _aiquery = "";
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool isLoading) {
    _loading = isLoading;
    notifyListeners();
  }

  void setCurrentProduct({required productId, required productName}) {
    _current_product_id = productId;
    _current_product_name = productName;
    notifyListeners();
  }

  void updateResults({
    required int total,
    int? totaldocs, // Added optional totaldocs parameter
    List<dynamic>? results,
    List<String>? suggested_prompts,
  }) {
    _total = 0;
    _results = [];
    if (suggested_prompts != null) _suggested_prompts = [];
    notifyListeners();

    _total = total;
    if (totaldocs != null)
      _totaldocs = totaldocs; // Update totaldocs if provided
    if (results != null) _results = results;
    if (suggested_prompts != null) _suggested_prompts = suggested_prompts;
    notifyListeners();
  }

  void updateSuggestedPrompts(List<String> suggested_prompts) {
    _suggested_prompts = [];
    notifyListeners();

    _suggested_prompts = suggested_prompts;
    notifyListeners();
  }

  void setCurrentSuggestions({required String suggestion}) {
    _current_suggestion = suggestion;
    notifyListeners();
  }

  void addResult(List<List<String>> result) {
    _total++;
    notifyListeners();
  }
}
