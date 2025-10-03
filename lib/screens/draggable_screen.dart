import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DraggableScreen extends StatefulWidget {
  const DraggableScreen({super.key});

  @override
  State<DraggableScreen> createState() => _DraggableScreenState();
}

class _DraggableScreenState extends State<DraggableScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(middle: Text("Draggable")),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Draggable Widget
            Draggable<CupertinoDynamicColor>(
              data: CupertinoColors.activeOrange,
              feedback: Container(
                height: 80,
                width: 80,
                color: CupertinoColors.activeOrange.withOpacity(0.7),
                child: Center(child: Text("Drag me",style: TextStyle(fontSize: 12),)),
              ),
              childWhenDragging: Container(
                height: 80,
                width: 80,
                color: CupertinoColors.inactiveGray,
                child: Center(child: Text("Dragging...",style: TextStyle(fontSize: 12))),
              ),
              child: Container(
                height: 80,
                width: 80,
                color: CupertinoColors.activeOrange,
                child: const Center(child: Text("Drag me",style: TextStyle(fontSize: 12))),
              ),
            ),
        
            // Drag Target
            DragTarget<Color>(
              onAccept: (color) {
                setState(() {
                  caughtColor = color;
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  height: 150,
                  width: 150,
                  color: caughtColor,
                  child: const Center(
                    child: Text("Drop here"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color caughtColor = CupertinoColors.inactiveGray;
}

class MyBlueBox {
}
