import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp2management/src/web_view_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'navigation_controls.dart';

class Scanner extends StatefulWidget {
  const Scanner();

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  bool _isFoundQRcode = false;
  late QRViewController controller;
  final controller2 = Completer<WebViewController>();

  static SnackBar snackBar = SnackBar(
    content:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
      Text(
        'Zlý QR kód! Naskenuj iný.',
        style: TextStyle(
          fontSize: 21,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.1,
        ),
      ),
      Icon(
        Icons.warning_amber_outlined,
        color: Colors.orange,
        size: 35,
      ),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return !_isFoundQRcode
        ? Scaffold(
            body: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              QRView(
                key: qrKey,
                onQRViewCreated: (r) => _onQRViewCreated(r, context),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade800,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Naskenuj QR kód staveniska',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ))
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue[700],
              toolbarHeight: 45,
              centerTitle: true,
              // Add from here ...
              actions: [
                NavigationControls(controller: controller2),
              ],
              // ... to here.
            ),
            body: SafeArea(
              child: WebViewStack(
                controller: controller2,
                url: qrText,
              ),
            ), // Add the controller argument
          );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      ScaffoldMessenger.of(context).clearSnackBars();
      setState(() {
        var domain = prefs.getString('domain');
        qrText = scanData.code.toString();
        if (qrText.contains(
            "http://$domain/TP2-App_for_construction_management/public/detail-staveniska/")) {
          _isFoundQRcode = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _isFoundQRcode = false;
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
