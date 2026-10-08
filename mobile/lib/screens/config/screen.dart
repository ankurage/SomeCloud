import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';

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

  Future saveConfig() async {
    var confProvider = context.read<ConfigProvider>();

    var newSyncPort = int.parse(confProvider.portSyncController.text);
    var newReceiverIp = confProvider.receiverIpController.text;

    confProvider.set(newReceiverIp, newSyncPort);
    
    var box = await Hive.openBox("cfg");
    box.putAt(0, {
      "receiverIp": newReceiverIp,
      "portSync": newSyncPort
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text("MyShare")),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: .center,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: DoubleTextFieldBackgrounddWidget(
                  fieldOne: Expanded(child: PortFieldWidget()),
                  fieldTwo: Expanded(child: ReceiverIpFieldWidget()),
                ),
              ),
            ),
            Align(
              alignment: .bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButtonWidget(
                        buttonPadding: EdgeInsetsGeometry.symmetric(vertical: 20),
                        onPressed: saveConfig,
                        child: Row(mainAxisAlignment: .center, children: [
                          Text("Save"),
                          Icon(Icons.done)
                        ],),
                      ),
                    ),
                  ),
                ],
              ),
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
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly
      ],
      textAlign: TextAlign.center,
      controller: context
          .read<ConfigProvider>()
          .portSyncController,
      decoration: InputDecoration(
        label: Row(
          mainAxisAlignment: .center,
          children: [
            Text("Port"),
          ],
        ),
        border: InputBorder.none
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
      textAlign: .center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9]"), replacementString: ".")
      ],
      controller: context
          .read<ConfigProvider>()
          .receiverIpController,
      decoration: InputDecoration(
        label: Row(
          mainAxisAlignment: .center,
          children: [
            Text("Receiver IP's"),
          ],
        ),
        border: InputBorder.none
      ),
    );
  }
}