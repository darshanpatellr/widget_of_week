// import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  final String title;
  final Widget widget;

  const ReusableContainer({
    super.key,
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: BoxBorder.all(color: CupertinoColors.opaqueSeparator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: CupertinoColors.activeBlue,
            ),
          ),
          SizedBox(height: 2),
          Divider(color: CupertinoColors.opaqueSeparator),
          SizedBox(height: 6),
          widget,
        ],
      ),
    );
  }
}
