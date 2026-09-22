import 'package:flutter/material.dart';

class ConfigProvider with ChangeNotifier {
  String receiverIp = "192.168.1.1";
  TextEditingController receiverIpController = TextEditingController();

  String get ip => receiverIp;

  void set(ip) {
    receiverIp = ip;
    notifyListeners();
  }

  @override
  void initState() {
    receiverIpController.text = "receiverIp";
  }
}

// class ClipBoardProvider with ChangeNotifier {
//   var clipboard;

  // Future<void> update() async {
  //   var text = await Clipboard.getData(Clipboard.kTextPlain);
  //   clipboard = clipboard?.text;
    
  // }
// }
