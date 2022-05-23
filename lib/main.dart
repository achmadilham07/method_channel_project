import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "";

  static const platform = MethodChannel('com.belajarubic.methodchannel');

  Future getMessageFromNative() async {
     try {
      message = await platform.invokeMethod('getMessage');
    } on PlatformException catch (e, s) {
      message = 'Failed to call get message: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await getMessageFromNative();
                setState(() {});
              },
              child: const Text("Get Data From Method Channel"),
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
