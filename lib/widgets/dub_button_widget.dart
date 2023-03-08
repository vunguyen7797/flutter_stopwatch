import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/utils/constants.dart';

class DubButton extends StatelessWidget {
  const DubButton({Key? key, this.color, required this.label, this.onTap})
      : super(key: key);

  final Color? color;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: (color ?? Colors.grey).withOpacity(0.1),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        width: 80,
        height: 80,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: onTap == null ? Colors.grey : color ?? Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
