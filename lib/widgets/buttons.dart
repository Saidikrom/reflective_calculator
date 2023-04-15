import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String title;
  Color? color;
  double? sizeh;
  double? sizew;
  Buttons({super.key, required this.title, this.sizeh, this.sizew, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizew ?? 80,
      height: sizeh ?? 76,
      decoration: BoxDecoration(
        color: color ?? const Color(0xff4E4E4E).withOpacity(.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            blurRadius: 100,
          )
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 36, color: Colors.white),
        ),
      ),
    );
  }
}
