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
      body: Stack(
        alignment: .center,
        children: [
          MessageField(messageController: _messageController),
          Align(
            alignment: .bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButtonWidget(
                      buttonPadding: EdgeInsetsGeometry.symmetric(vertical: 20),
                      child: isServiceActive ? Text("Stop Sync") : Text("Start Sync"),
                      onPressed: () {
                        if (isServiceActive) {
                          FlutterBackgroundService().invoke("stopService");
                        } else {
                          FlutterBackgroundService().startService();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
  bool isServersListOpened = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      spacing: 0,
      mainAxisAlignment: .center,
      children: [
        AnimatedContainer(
          padding: EdgeInsetsGeometry.zero,
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadiusGeometry.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          height: isServersListOpened ? 200 : 0,
          width: isServersListOpened ? 230 : 0,
          duration: Duration(milliseconds: 100),
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Device Name"),
                subtitle: Text("Ip........"),
                trailing: Text("Port..."),
              );
            },
          )
        ),
        Row(
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            IconButtonBackgroundWidget(
              buttonPadding: .symmetric(vertical: 17, horizontal: 17),
              onPressedSuffix: sendMessage,
              onPressedPrefix: serversListToggle,
              left: false,
              suffixIcon: Icon(Icons.send),
              prefixIcon: Icon(Icons.list),
              child: SizedBox(
                width: 150,
                child: MessageSendWidget(widget: widget),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void serversListToggle() {
    setState(() {
      isServersListOpened = !isServersListOpened;
    });
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
        label: Row(
          mainAxisAlignment: .center,
          children: [
            Consumer<ConfigProvider>(
              builder: (context, value, child) =>
                  Text("Send Message"),
              // child: Text("Message To ${context.read<ConfigProvider>().ip}")
            ),
          ],
        ),
        border: InputBorder.none
      ),
    );
  }
}
