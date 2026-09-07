import 'dart:io';

import 'package:flutter/material.dart';
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
            // IntrinsicWidth(
            //   child: ListView.separated(
            //     itemBuilder: (context, index) {
            //       return
            //     },
            //     separatorBuilder: (c, i) => Divider(),
            //     itemCount: 1,
            //   ),
            // ),

            IntrinsicWidth(
              child: Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        label: Consumer<ConfigProvider>(
                          builder: (context, value, child) => Text("Message To ${value.ip}"),
                          // child: Text("Message To ${context.read<ConfigProvider>().ip}")
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButtonWidget(
                    child: Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future sendMessage() async {
    final socket = await Socket.connect(
      context.read<ConfigProvider>().receiverIp, // IP ноутбука
      5000,
    );

    socket.write(_messageController.text);

    await socket.flush();
    await socket.close();
  }
}