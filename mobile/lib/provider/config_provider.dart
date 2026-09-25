import 'package:flutter/material.dart';

class ConfigProvider with ChangeNotifier {
  String receiverIp = "192.168.1.1";
  int portSync = 5000;

  TextEditingController receiverIpController = TextEditingController();
  TextEditingController portSyncController = TextEditingController();

  String get ip => receiverIp;
  int get port => portSync;

  void set(ip, port) {
    receiverIp = ip;
    portSync = port;
    notifyListeners();
  }
}
