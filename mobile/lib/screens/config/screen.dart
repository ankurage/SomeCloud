import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/config_provider.dart';

class ConfigScreen extends StatefulWidget {
  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  void initState() {
    super.initState();
    var confProvider = context.read<ConfigProvider>();
    confProvider.receiverIpController.text = confProvider.ip;
    confProvider.portSyncController.text = confProvider.port.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var confProvider = context.read<ConfigProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("MyShare")),
      body: Padding(
        padding: const EdgeInsets.all(70.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: 0,
              children: [
                Expanded(child: ReceiverIpFieldWidget()),
                Expanded(child: PortFieldWidget())
              ],
            ),
            ElevatedButton(
              child: Row(mainAxisAlignment: .center, children: [
                Text("Save"),
                Icon(Icons.done)
              ],),
              onPressed: () async {
                confProvider.set(confProvider.receiverIpController.text, int.parse(confProvider.portSyncController.text));
                var box = await Hive.openBox("cfg");
                box.putAt(0, {
                  "receiverIp": "${confProvider.receiverIpController.text}",
                  "port": confProvider.port
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PortFieldWidget extends StatelessWidget {
  const PortFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context
          .read<ConfigProvider>()
          .portSyncController,
      decoration: InputDecoration(
        label: Text("Port"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}

class ReceiverIpFieldWidget extends StatelessWidget {
  const ReceiverIpFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context
          .read<ConfigProvider>()
          .receiverIpController,
      decoration: InputDecoration(
        label: Text("Receiver IP's"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}