import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chatuiv2/src/classes/_urls.dart';

class SocketService {
  static IO.Socket? socket;
  static bool isConnected = false;
  static final String socketUrl = Urls.socketUrl;

  static final StreamController<Map<String, dynamic>> _transactionController =
      StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get transactionStream =>
      _transactionController.stream;

  static void connectToSocketServer() {
    socket = IO.io(socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.connect();

    socket!.onConnect((_) {
      isConnected = true;
      print('Connected to socket server');
    });

    socket!.on('transaction.success', (data) {
      print('Payment successful: $data');

      _transactionController.add(data);
    });
  }

  static void disconnectFromSocketServer() {
    socket?.disconnect();
    socket = null;
    isConnected = false;
    _transactionController.close();
  }
}
