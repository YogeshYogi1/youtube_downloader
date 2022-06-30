import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_downloader/downloader.dart';
import 'dart:math';

class PasteLinkPage extends StatefulWidget {
  const PasteLinkPage({Key? key}) : super(key: key);

  @override
  State<PasteLinkPage> createState() => _PasteLinkPageState();
}

class _PasteLinkPageState extends State<PasteLinkPage> {
  TextEditingController _textcontroller = TextEditingController();

  List<Format> resolution = [
    Format(itag: 18, resolution: 360),
    Format(itag: 83, resolution: 480),
    Format(itag: 22, resolution: 720),
    Format(itag: 37, resolution: 1080)
  ];

  int selectedres = 0;

  _showDialog() {
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
                        onPressed: () {
                          setState(() {
                            selectedres = index;
                          });
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

  List<Color> colormain = [
    Colors.white,
    Colors.teal,
    Colors.deepPurple.shade600,
    Colors.pinkAccent,
    Colors.yellow
  ];
  int selectedcolor = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colormain[selectedcolor],
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              setState(() {
                selectedcolor = Random().nextInt(5) + 0;
              });
            },
            child: const Icon(Icons.color_lens_outlined)),
        backgroundColor: Colors.black38,
        title: const Text('Worm Hole'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _textcontroller,
                decoration:
                    const InputDecoration(hintText: 'Paste your link here'),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () {
                if (_textcontroller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.all(15),
                      content: Text('No Link Pasted'),
                    ),
                  );
                } else {
                  //download video
                  Download().downloadVideo(_textcontroller.text.trim(), 'Ryuk.',
                      resolution[selectedres].itag);
                }
                print(resolution[selectedres].itag);
              },
              label: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('Download'),
              ),
              icon: const Icon(Icons.download_outlined),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: colormain[selectedcolor],
        elevation: 15,
        onPressed: () {
          setState(() {
            _showDialog();
          });
        },
        child: Text(resolution[selectedres].resolution.toString() + 'p'),
      ),
    );
  }
}
