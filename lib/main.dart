import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

void main() {
  runApp(ARWebView(url: 'https://webarvsar.web.app'));
}

class ARWebView extends StatefulWidget {
  final String url;

  const ARWebView({required this.url});

  @override
  _ARWebViewState createState() => _ARWebViewState();
}

class _ARWebViewState extends State<ARWebView> {
  late WebViewController _webViewController;
  late ArCoreController _arCoreController;

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
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
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

  void _onNodeTap(String name) async {
    await _webViewController.evaluateJavascript("document.getElementById('$name').click()");
  }
}
