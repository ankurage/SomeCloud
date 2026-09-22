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
          children: [
            IntrinsicWidth(
              child: IntrinsicHeight(
                child: Row(
                  spacing: 0,
                  crossAxisAlignment: .stretch,
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
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButtonWidget(
                      child: Icon(Icons.done),
                      onPressed: () {
                        context.read<ConfigProvider>().set(context.read<ConfigProvider>().receiverIpController.text);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}