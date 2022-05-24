import 'dart:convert';

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
  String directMessage = "default";
  String errorMessage = "default";
  String paramMessage = "default";
  String getMessage = "default";

  static const platform = MethodChannel('com.belajarubic.methodchannel');

  Future getDirectMessageFromNative() async {
    try {
      directMessage = await platform.invokeMethod('getDirectMessage');
    } on PlatformException catch (e, s) {
      directMessage = 'Failed to call get direct message: $e';
    }
  }

  Future getErrorMessageFromNative() async {
    try {
      errorMessage = await platform.invokeMethod('getErrorMessage');
    } on PlatformException catch (e, s) {
      errorMessage = 'Failed to call get error message: $e';
    }
  }

  Future getParamMessageFromNative() async {
    try {
      paramMessage = await platform.invokeMethod(
        'getMessageFromParam',
        {"param1": 1},
      );
    } on PlatformException catch (e, s) {
      paramMessage = 'Failed to call get message: $e';
    }
  }

  Future getMessageFromNative() async {
    try {
      getMessage = await platform.invokeMethod(
        'getMessageFromNative',
      );
    } on PlatformException catch (e, s) {
      getMessage = 'Failed to call get message from native: $e';
    }
  }

  Future initNativeMethodHandler() async {
    platform.setMethodCallHandler((call) async {
      final argument = call.arguments.toString();
      switch (call.method) {
        case 'fromNative':
          Map<String, dynamic> json = jsonDecode(argument);
          getMessage = json['message'];
          break;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    initNativeMethodHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Method Channel Project"),
      ),
      body: Center(
        child: Column(
          children: [
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                await getDirectMessageFromNative();
                setState(() {});
              },
              child: const Text("Sent and Get Direct Data From Method Channel"),
            ),
            Text(directMessage),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                await getErrorMessageFromNative();
                setState(() {});
              },
              child: const Text("Sent and Get Error From Method Channel"),
            ),
            Text(errorMessage),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                await getParamMessageFromNative();
                setState(() {});
              },
              child: const Text("Sent and Get Param From Method Channel"),
            ),
            Text(paramMessage),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                await getMessageFromNative();
                setState(() {});
              },
              child: const Text("Get Message From Method Channel"),
            ),
            Text(getMessage),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
