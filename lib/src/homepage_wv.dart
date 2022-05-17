import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp2management/src/web_view_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'navigation_controls.dart';

class HomepageWv extends StatefulWidget {
  const HomepageWv({Key? key}) : super(key: key);

  @override
  State<HomepageWv> createState() => _HomepageWvState();

}

class _HomepageWvState extends State<HomepageWv> {
  final controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: callAsyncFetch(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue[700],
                toolbarHeight: 45,
                centerTitle: true,
                // Add from here ...
                actions: [
                  NavigationControls(controller: controller),
                ],
                // ... to here.
              ),
              body: SafeArea(
                child: WebViewStack(
                  controller: controller,
                  url:
                  'http://${snapshot.data.toString()}/TP2-App_for_construction_management/public/',
                ),
              ), // Add the controller argument
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }

  callAsyncFetch() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('domain');
  }
}