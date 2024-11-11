import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_message.dart';

class MessageProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => List.unmodifiable(_messages);

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
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
}
