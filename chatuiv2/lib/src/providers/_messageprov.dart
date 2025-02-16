import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_message.dart';

class MessageProvider extends ChangeNotifier {
  final List<Message> _messages = [];
  int _previousLength = 0;
  int _currentMessageIndex = 0; // Add this line

  List<Message> get messages => List.unmodifiable(_messages);
  int get currentMessageIndex => _currentMessageIndex;

  void addMessage(Message message) {
    _previousLength = _messages.length;
    _messages.add(message);

    notifyListeners();
  }

  void setCurrentMessage(int index) {
    if (index >= 0 && index < _messages.length) {
      _currentMessageIndex = index;
      notifyListeners();
    }
  }

  List<Message> getMessagesInReverse() {
    return messages.reversed.toList();
  }

  void removeLastMessage() {
    if (_messages.isNotEmpty) {
      _messages.removeLast();
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  bool get lengthChanged => _messages.length != _previousLength;
  int get lengthDifference => _messages.length - _previousLength;
}
