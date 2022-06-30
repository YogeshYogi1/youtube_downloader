import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_downloader/downloader.dart';

class BrowseLinkPage extends StatefulWidget {
  const BrowseLinkPage({Key? key}) : super(key: key);

  @override
  State<BrowseLinkPage> createState() => _BrowseLinkPageState();
}

class _BrowseLinkPageState extends State<BrowseLinkPage> {
  String link = 'https://www.youtube.com';
  WebViewController? _controller;
  bool _showdownload = false;

  void checkurl() async {
    if (await _controller!.currentUrl() == 'https://m.youtube.com/') {
      setState(() {
        _showdownload = false;
      });
    } else {
      setState(() {
        _showdownload = true;
      });
    }
  }

  List<Format> resolution = [
    Format(itag: 18, resolution: 360),
    Format(itag: 83, resolution: 480),
    Format(itag: 22, resolution: 720),
    Format(itag: 37, resolution: 1080)
  ];

  int selectedres = 0;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(actions: [
          Container(
            color: Colors.transparent,
            height: 310,
            width: 300,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: resolution.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 17, bottom: 10, left: 10, right: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () async {
                          setState(() {
                            selectedres = index;
                          });
                          print(resolution[selectedres].itag);
                          final uri = await _controller!.currentUrl();
                          final title = await _controller!.getTitle();

                          Download().downloadVideo(
                              uri!, title! + '.', resolution[selectedres].itag);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(resolution[index].resolution.toString()),
                        )),
                  );
                }),
          ),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    checkurl();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await _controller!.canGoBack()) {
            _controller!.goBack();
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: WebView(
            initialUrl: link,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              setState(() {
                _controller = controller;
              });
            },
          ),
          floatingActionButton: _showdownload == false
              ? Container()
              : FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {
                    _showDialog();
                  },
                  child: const Icon(Icons.download_outlined),
                ),
        ),
      ),
    );
  }
}
