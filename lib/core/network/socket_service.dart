
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(String userId) {
    socket = IO.io(
      'http://45.129.87.38:6065',
      IO.OptionBuilder().setTransports(['websocket']).enableForceNew().disableAutoConnect().build(),
    );
    socket.connect();
    socket.onConnect((_) {
      print('Socket connected');
      socket.emit('join', {'userId': userId});
    });
    socket.onDisconnect((_) => print('Socket disconnected'));
  }

  void sendMessage(Map<String, dynamic> message) {
    socket.emit('send_message', message);
  }

  void onReceive(void Function(dynamic) cb) {
    socket.on('receive_message', cb);
  }

  void dispose() {
    try {
      socket.disconnect();
    } catch (e) {
      // ignore
    }
  }
}
