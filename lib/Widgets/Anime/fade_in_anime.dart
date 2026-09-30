import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  FadeInWidgetState createState() => FadeInWidgetState();
}

class FadeInWidgetState extends State<FadeInWidget> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Set _visible to true after the specified duration to trigger the animation.
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: widget.duration,
      child: widget.child,
    );
  }
}
