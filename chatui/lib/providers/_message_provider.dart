import 'package:flutter/foundation.dart';

import 'package:chat/classes/_message.dart';
import 'package:chat/classes/_url.dart';

class MessageProvider extends ChangeNotifier {
  static final PayoorUrl payoorUrl = PayoorUrl();
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  int get messageCount => _messages.length;

  void addMessage(Message message) {
    _messages.add(message);

    notifyListeners();
  }

  void addMessageToBeginning(Message message) {
    _messages.insert(0, message);

    notifyListeners();
  }

  void removeMessage(int index) {
    if (index >= 0 && index < _messages.length) {
      _messages.removeAt(index);
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  Message? getMessageAt(int index) {
    if (index >= 0 && index < _messages.length) {
      return _messages[index];
    }
    return null;
  }

  void setMessages(List<Message> newMessages) {
    _messages.clear();
    _messages.addAll(newMessages);
    notifyListeners();
  }
}
