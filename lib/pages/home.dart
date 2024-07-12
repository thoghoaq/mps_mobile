import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late InAppWebViewController inAppWebViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InAppWebView(
      initialUrlRequest:
          URLRequest(url: WebUri("https://mps-client-ashen.vercel.app/")),
      onWebViewCreated: (controller) {
        inAppWebViewController = controller;
      },
    ));
  }
}
