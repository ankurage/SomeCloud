import 'package:flutter/material.dart';
import 'package:mobile/widgets/buttons_widget.dart';
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
    context.read<ConfigProvider>().receiverIpController.text = context.read<ConfigProvider>().ip;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("MyShare")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: .stretch,
          children: [
            IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: context
                          .read<ConfigProvider>()
                          .receiverIpController,
                      decoration: InputDecoration(
                        label: Text("Receiver IP's"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButtonWidget(
                      child: Icon(Icons.done),
                      onPressed: () {
                        context.read<ConfigProvider>().set(context.read<ConfigProvider>().receiverIpController.text);
                      },
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