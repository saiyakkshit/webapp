import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(
        child: MyApp(),
      ),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ArCoreController _arCoreController;
  InAppWebViewController? _webViewController;

  @override
  void dispose() {
    _arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AR Website"),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse("https://webarvsar.web.app"),
            ),
            initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
                useWideViewPort: true,
                javaScriptEnabled: true,
              ),
              ios: IOSInAppWebViewOptions(),
              crossPlatform: InAppWebViewOptions(),
            ),
            onWebViewCreated: (InAppWebViewController webViewController) {
              _webViewController = webViewController;
            },
            onLoadStop: (controller, url) {
              _arCoreController.resume();
            },
          ),
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController arCoreController) {
    _arCoreController = arCoreController;
    _arCoreController.onNodeTap = (name) => _onNodeTap(name);
  }

  void _onNodeTap(String name) {
    _webViewController?.evaluateJavascript(source: "document.getElementById('$name').click();");
  }
}
