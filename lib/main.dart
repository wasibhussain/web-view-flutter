import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: WebViewContainer(),
        ),
      ),
    );
  }
}

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({Key? key}) : super(key: key);

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  bool _isLoadingPage = true;
  bool _isConnected = true;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = (connectivityResult != ConnectivityResult.none);
    });

    if (_isConnected) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              const Center(
                child: CircularProgressIndicator(),
              );
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoadingPage = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoadingPage = false;
              });
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse('https://goldanprediction.com/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isConnected
          ? Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoadingPage)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            )
          : const Center(
              child: Text(
                'Please connect to the Internet!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
