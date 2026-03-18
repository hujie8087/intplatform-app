import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:uuid/uuid.dart';

typedef WsOnMessage = void Function(Map<String, dynamic> message);

class WebSocketService {
  final String url;
  final Map<String, String>? headers;
  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  bool _manuallyClosed = false;
  final _rand = Uuid();

  // 外部订阅
  final List<WsOnMessage> _listeners = [];

  // 重连策略
  int _reconnectAttempt = 0;

  WebSocketService(this.url, {this.headers});

  Future<void> connect() async {
    _manuallyClosed = false;
    _connect();
  }

  void _connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _sub = _channel!.stream.listen(
        (data) {
          try {
            final decoded = jsonDecode(data);
            for (var l in _listeners) l(decoded);
          } catch (e) {
            print('WS decode error: $e, raw: $data');
          }
        },
        onDone: () {
          print('WS done, will reconnect? manuClose=$_manuallyClosed');
          _channel = null;
          _sub = null;
          if (!_manuallyClosed) _tryReconnect();
        },
        onError: (err) {
          print('WS error: $err');
          _channel = null;
          _sub = null;
          if (!_manuallyClosed) _tryReconnect();
        },
        cancelOnError: true,
      );

      // reset reconnect counter on success
      _reconnectAttempt = 0;

      // 心跳（简单示例，可根据后端约定改）
      Timer.periodic(Duration(seconds: 25), (t) {
        if (_channel == null)
          t.cancel();
        else
          send({
            'action': 'ping',
            'payload': {'ts': DateTime.now().millisecondsSinceEpoch},
          });
      });
    } catch (e) {
      print('WS connect exception: $e');
      _tryReconnect();
    }
  }

  void _tryReconnect() {
    _reconnectAttempt++;
    final delay =
        (_reconnectAttempt <= 5)
            ? 1 << (_reconnectAttempt - 1)
            : 30; // 指数回退，最大30s
    print('Reconnecting in $delay s');
    Future.delayed(Duration(seconds: delay), () => _connect());
  }

  void addListener(WsOnMessage l) {
    _listeners.add(l);
  }

  void removeListener(WsOnMessage l) {
    _listeners.remove(l);
  }

  void send(Map<String, dynamic> data) {
    final jsonStr = jsonEncode(data);
    try {
      _channel?.sink.add(jsonStr);
    } catch (e) {
      print('WS send error: $e');
    }
  }

  void close({bool manual = true}) {
    _manuallyClosed = manual;
    _sub?.cancel();
    _channel?.sink.close();
    _channel = null;
  }

  // 辅助：构建并发送文本消息
  void sendTextMessage({
    required String from,
    required String to,
    required String text,
  }) {
    final id = _rand.v4();
    send({
      'action': 'message',
      'payload': {
        'id': id,
        'from': from,
        'to': to,
        'type': 'text',
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    });
  }
}
