import 'dart:async'; // Add this import
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp2management/src/homepage_wv.dart';
import 'package:tp2management/src/qr_scan.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Add this import back

import 'src/navigation_controls.dart'; // Add this import
import 'src/web_view_stack.dart';

void main() {
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue[800],
    statusBarColor: Colors.blue[700],
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));
}

bool isLoading = true;
const int loadingTime = 850;

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final textController = TextEditingController();
  final controller =
      Completer<WebViewController>(); // Instantiate the controller

  void startTimer() {
    int randomLoadNumber;
    Random random = Random();
    randomLoadNumber = random.nextInt(1000) + loadingTime;
    print(randomLoadNumber);
    Timer.periodic(Duration(milliseconds: randomLoadNumber), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textController.dispose();
    super.dispose();
  }

  void setText() async {
    final prefs = await SharedPreferences.getInstance();
    textController.text = prefs.getString('domain') ?? 'Zadaj doménu';
  }

  @override
  void initState() {
    setText();
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Material(
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                      0.05,
                      0.15,
                      0.30,
                      0.45,
                      0.60,
                      0.75,
                      0.90,
                      0.99
                    ],
                    colors: [
                      Colors.blue.shade700,
                      Colors.blue.shade700,
                      Colors.blue.shade700,
                      Colors.blue.shade700,
                      Colors.blue.shade800,
                      Colors.blue.shade800,
                      Colors.blue.shade800,
                      Colors.blue.shade800,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.construction_rounded,
                          size: 115,
                          color: Colors.lightBlueAccent,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    LoadingBouncingGrid.square(
                      backgroundColor: Colors.blue,
                      borderColor: Colors.black,
                      inverted: true,
                      size: 85,
                      borderSize: 4,
                    ),
                    const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "0.4.0",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                  ],
                )))
        : Material(
            color: Colors.transparent,
            child: Scaffold(
              body: SafeArea(
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [
                          0.05,
                          0.15,
                          0.30,
                          0.45,
                          0.60,
                          0.75,
                          0.90,
                          0.99
                        ],
                        colors: [
                          Colors.blue.shade700,
                          Colors.blue.shade700,
                          Colors.blue.shade700,
                          Colors.blue.shade700,
                          Colors.blue.shade800,
                          Colors.blue.shade800,
                          Colors.blue.shade800,
                          Colors.blue.shade800,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            const Icon(
                              Icons.construction_rounded,
                              size: 115,
                              color: Colors.lightBlueAccent,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Manažment Stavenísk',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: <Widget>[
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    minimumSize: const Size(300, 60),
                                    fixedSize: const Size(300, 60)),
                                onPressed: () async {
                                  final prefs =
                                  await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'domain', textController.text);
                                  final snackBar = SnackBar(
                                    content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            'Doména uložená',
                                            style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                          Icon(Icons.check, color: Colors.green, size: 35,),
                                        ]),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                icon: const Icon(Icons.link,
                                    size: 50, color: Colors.lightBlueAccent),
                                label: TextField(
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  controller: textController,
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    minimumSize: const Size(300, 60),
                                    fixedSize: const Size(300, 60)),
                                onPressed: () async {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const HomepageWv()));
                                },
                                icon: const Icon(Icons.double_arrow_outlined,
                                    size: 50, color: Colors.lightBlueAccent),
                                label: Text(
                                  'Vstúpiť do systému',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    minimumSize: const Size(300, 60),
                                    fixedSize: const Size(300, 60)),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Scanner()));
                                },
                                icon: const Icon(Icons.qr_code,
                                    size: 50, color: Colors.lightBlueAccent),
                                label: Text(
                                  'Naskenovať kód staveniska',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                      ],
                    )), // Add the controller argument
              ),
            ));
  }
}
