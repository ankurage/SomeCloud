import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

//------------------
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

//------------------
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  var oldClip = "";
  if (service is AndroidServiceInstance) {
    service.on("setAsForeground").listen((event) {
      service.setAsForegroundService();
    });
    service.on("setAsBackground").listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on("stopService").listen((event) {
    service.stopSelf();
  });
  service.on("clipboardResult").listen((event) async {
    final text = event?["text"];
    if (oldClip == text) {return;}
    else {
      final socket = await Socket.connect(
        event?["receiverIp"], // IP ноутбука
        event?["portSync"],
      );

      socket.write(text);

      await socket.flush();
      await socket.close();
      oldClip = text;
    }
  });

  Timer.periodic(Duration(seconds: 1), (timer) async {
    service.invoke("getClipboard");
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(title: "Sync...", content: "Click for open");
      }
    }
  });
}