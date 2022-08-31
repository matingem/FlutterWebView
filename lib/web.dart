import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

void web () => runApp(const MaterialApp(
  home:  Home(),
));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late WebViewController _webViewController;
  double webProgress = 0;
  bool isError = false;
  bool _isVisible = true;




  @override
  Widget build(BuildContext context) {

    void showToast() {
      setState(() {
        _isVisible = !_isVisible;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        if(await _webViewController.canGoBack()){
          _webViewController.goBack();
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          title: const Text('H E L L O', style: TextStyle(color: Colors.red),),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () => _webViewController.goBack(), icon: const Icon(Icons.refresh , color: Colors.red)),
          ],
          leading: IconButton(
            onPressed: () async {
              if(await _webViewController.canGoBack()){
                _webViewController.goBack();
              }

            },
            icon: const Icon(Icons.arrow_back, color: Colors.red),
          ),
        ),
        body: Stack(
          children: [
            if(!isError)
              webProgress < 1 ? SizedBox(
                height: 5,
                child: LinearProgressIndicator(
                    value: webProgress,
                    color: Colors.red,
                    backgroundColor: Colors.black
                ),

              ) : const SizedBox(),
            Expanded(
              child: Visibility(
                visible: _isVisible,
              child: WebView(
                initialUrl: 'https://toptech.shop',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated:(WebViewController controller){ _webViewController=controller; },
                onProgress: (progress) => setState((){
                  webProgress = progress/100;
                }) ,
                onWebResourceError: (error) => setState(() {
                  isError = true;
                  showToast();
                }),
              ),
              ),
            ),
            if (isError)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                  children: <Widget>[
                    Lottie.asset('images/int.json'),
                    ElevatedButton(onPressed: () {_webViewController.reload(); showToast(); isError= false;}, child: Icon(Icons.refresh))

    ],
               ),
                )


            ),
          ],
        ),

      ),

    );
  }
}
