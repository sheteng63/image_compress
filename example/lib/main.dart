import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_compress/image_compress.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<int> _platformVersion ;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    List<int> platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
          var memory = await ImageCompress.compressImageToMemory("");
    } on PlatformException {

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: _platformVersion != null?
              Image.memory(_platformVersion,)
              :Text("还未完成")
        ),
        floatingActionButton: GestureDetector(
          child: ClipOval(
              child: SizedBox(
                width: 70.0,
                height: 70.0,
                // ignore: ambiguous_import
                child: Container(
                  color: Colors.red,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )),
          onTap: initPlatformState,
        ),
      ),
    );
  }
}
