import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(
        channel: new IOWebSocketChannel.connect("ws://echo.websocket.org"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({@required this.channel});

  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Web Socket"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Form(
              child: new TextFormField(
                decoration: new InputDecoration(labelText: "Send any message"),
                controller: editingController,
              ),
            ),
            new StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return new Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.send),
        onPressed: _sendMyMessage,
      ),
    );
  }

  void _sendMyMessage() {
    if (editingController.text.isNotEmpty) {
      widget.channel.sink.add(editingController.text);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
