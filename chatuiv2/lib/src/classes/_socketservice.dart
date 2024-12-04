import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chatuiv2/src/classes/_urls.dart';

class SocketService {
  static IO.Socket? socket;
  static bool isConnected = false;
  static final String socketUrl = Urls.socketUrl;

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
      // Handle your payment success data here
    });
  }

  static void disconnect() {
    socket?.disconnect();
    socket = null;
    isConnected = false;
  }
}
