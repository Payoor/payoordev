import 'package:flutter/material.dart';

class ResultListProvider extends ChangeNotifier {
  int _total;
  List<Map<String, dynamic>> _results;
  List<Map<String, dynamic>> _suggested_prompts; 

  ResultListProvider({
    int total = 0,
    List<Map<String, dynamic>> results = const [],
    List<Map<String, dynamic>> suggested_prompts = const [],
  }) : _total = total,
       _results = results,
       _suggested_prompts = suggested_prompts;

  int get total => _total;
  List<Map<String, dynamic>> get results => _results;
  List<Map<String, dynamic>> get suggested_prompts => _suggested_prompts; 

  void updateResults({
    required int total,
    List<Map<String, dynamic>>? results,
    List<Map<String, dynamic>>? suggested_prompts,
  }) {
    _total = total;
    if (results != null) _results = results;
    if (suggested_prompts != null) _suggested_prompts = suggested_prompts;
    notifyListeners();
  }

  void addResult(Map<String, dynamic> result) {
    _results = [..._results, result];
    _total++;
    notifyListeners();
  }

  void updateSuggestedPrompts(List<Map<String, dynamic>> prompts) { 
    _suggested_prompts = prompts;
    notifyListeners();
  }
}