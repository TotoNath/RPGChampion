import 'package:flutter/cupertino.dart';

class AnimatedDot extends StatelessWidget {
  const AnimatedDot({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
          color: isActive
              ? Color(0xFFFFFFFF)
              : Color(0xFFDFDFDF).withOpacity(0.15),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}