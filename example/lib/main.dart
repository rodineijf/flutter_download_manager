import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = FlutterDownloadManagerController(
    'https://file-examples-com.github.io/uploads/2017/10/file_example_JPG_2500kB.jpg',
  );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that w as created by
          // the App.build method, and use it to set our appBar title.
          title: Text(widget.title),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FlutterDownloadManagerBuilder(
                    autoStart: false,
                    controller: _controller,
                    builder: (context, snap, child) {
                      if (snap.file != null) {
                        return FutureBuilder<Uint8List>(
                          future: snap.file!.readAsBytes(),
                          builder: (context, snap) {
                            if (snap.data != null) {
                              return Image.memory(snap.data!);
                            }
                            return const SizedBox();
                          },
                        );
                      }
                      return Text(
                          '${snap.progress.toString()} + ${snap.status}');
                    },
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Download'),
                onPressed: () {
                  _controller.start();
                },
              ),
            ],
          ),
        ));
  }
}
