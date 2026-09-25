import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mobile/provider/config_provider.dart';
import 'package:mobile/widgets/buttons_widget.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShare'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/config");
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            IntrinsicWidth(
              child: IntrinsicHeight(
                child: MessageField(messageController: _messageController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageField extends StatefulWidget {
  const MessageField({
    super.key,
    required this._messageController,
  });

  final TextEditingController _messageController;

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  bool isServiceActive = false;
  
  Future checkServiceActive() async {
    bool isRunning = await FlutterBackgroundService().isRunning();
    setState(() {
      isServiceActive = isRunning;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (_) {
      checkServiceActive();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 0,
      crossAxisAlignment: .stretch,
      children: [
        IconButtonWidget(
          child: isServiceActive ? Text("Stop Sync") : Text("Start Sync"),
          onPressed: () {
            if (isServiceActive) {
              FlutterBackgroundService().invoke("stopService");
            } else {
              FlutterBackgroundService().startService();
            }
          },
        ),
        SizedBox(
          width: 250,
          child: MessageSendWidget(widget: widget),
        ),
        IconButtonWidget(
          child: Icon(Icons.send),
          onPressed: sendMessage,
          left: false,
        ),
      ],
    );
  }

  Future sendMessage() async {
    final socket = await Socket.connect(
      context.read<ConfigProvider>().ip, // IP ноутбука
      context.read<ConfigProvider>().port,
    );

    socket.write(widget._messageController.text);

    await socket.flush();
    await socket.close();
  }
}

class MessageSendWidget extends StatelessWidget {
  const MessageSendWidget({
    super.key,
    required this.widget,
  });

  final MessageField widget;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._messageController,
      decoration: InputDecoration(
        label: Consumer<ConfigProvider>(
          builder: (context, value, child) =>
              Text("Message To ${value.ip}"),
          // child: Text("Message To ${context.read<ConfigProvider>().ip}")
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          )
        ),
      ),
    );
  }
}
