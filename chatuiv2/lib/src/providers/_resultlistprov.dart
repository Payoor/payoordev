import 'package:flutter/material.dart';

class ResultListProvider extends ChangeNotifier {
  int _total = 0;
  List<Map<String, String>> _results = [];
  List<String> _suggested_prompts = [];
  //List<Map<String, dynamic>> _current_product_data = [];
  String _current_product_name = "";
  String _current_product_id = "";
  String _current_suggestion = "";

  ResultListProvider({
    int total = 0,
    List<Map<String, String>> results = const [],
    List<String> suggested_prompts = const [],
  }) {
    _total = total;
    _results = results;
    _suggested_prompts = suggested_prompts;
  }

  int get total => _total;
  List<Map<String, String>> get results => _results;
  List<String> get suggested_prompts => _suggested_prompts;
  String get current_product_name => _current_product_name;
  String get current_product_id => _current_product_id;
  String get current_suggestion => _current_suggestion; // Added missing getter

  void setCurrentProduct({required productId, required productName}) {
    _current_product_id = productId;
    _current_product_name = productName;
    notifyListeners();
  }

  void updateResults({
    required int total,
    List<Map<String, String>>? results,
    List<String>? suggested_prompts,
  }) {
    _total = 0;
    _results = [];
    if (suggested_prompts != null) _suggested_prompts = [];
    notifyListeners();

    _total = total;
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
    //print('changes');
    //print(_current_suggestion);
    notifyListeners();
  }

  void addResult(List<List<String>> result) {
    //_results = [..._results, result];
    _total++;
    notifyListeners();
  }
}
