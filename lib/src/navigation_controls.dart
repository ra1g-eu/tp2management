import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tp2management/src/homepage_wv.dart';
import 'package:tp2management/src/qr_scan.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, Key? key})
      : super(key: key);

  final Completer<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, snapshot) {
        final WebViewController? controller = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done ||
            controller == null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Icon(Icons.qr_code),
              Icon(Icons.replay),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home_outlined, size: 30),
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WebViewApp())
                );
              },
            ),
            const VerticalDivider(color: Colors.transparent,width: 20),
            IconButton(
              icon: const Icon(Icons.qr_code, size: 30),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Scanner())
                );
              },
            ),
            const VerticalDivider(color: Colors.transparent,width: 20),
            /*IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No back history item')),
                  );
                  return;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (await controller.canGoForward()) {
                  await controller.goForward();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No forward history item')),
                  );
                  return;
                }
              },
            ),*/
            IconButton(
              icon: const Icon(Icons.replay, size: 30,),
              onPressed: () {
                controller.reload();
              },
            ),
          ],
        );
      },
    );
  }
}
