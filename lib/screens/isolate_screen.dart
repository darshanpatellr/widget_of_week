import 'dart:isolate';
import 'package:flutter/cupertino.dart';

void heavyComputation(SendPort sendPort) {
  int sum = 0;
  const totalIterations = 1000000000;
  const updateInterval = totalIterations ~/ 10; // Update every 10%

  for (int i = 0; i < totalIterations; i++) {
    sum += i;
    // Send progress update every 10%
    if (i % updateInterval == 0 && i != 0) {
      double progress = (i / totalIterations) * 100;
      sendPort.send("Progress: ${progress.toStringAsFixed(1)}%");
    }
  }
  // Send final result
  sendPort.send("Computation complete: $sum");
}

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  String result = "Press button to start";

  Isolate? _isolate;
  ReceivePort? _receivePort;

  Future<void> runHeavyTask() async {
    setState(() {
      result = "Starting...";
    });

    // Create a new ReceivePort
    _receivePort = ReceivePort();
    try {
      // Spawn the isolate
      _isolate = await Isolate.spawn(heavyComputation, _receivePort!.sendPort);

      // Listen for messages from the isolate
      _receivePort!.listen((message) {
        setState(() {
          result = message;
        });

        // Optionally, stop listening if the final result is received
        if (message.toString().startsWith("Computation complete")) {
          _receivePort?.close();
          _isolate?.kill(priority: Isolate.immediate);
          _isolate = null;
        }
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  @override
  void dispose() {
    // Clean up the isolate and ReceivePort when the widget is disposed
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(middle: Text("Isolate")),
      child: SafeArea(
        child: CupertinoButton.filled(
          child: Text(result),
          onPressed: () {
            runHeavyTask();
          },
        ),
      ),
    );
  }
}
