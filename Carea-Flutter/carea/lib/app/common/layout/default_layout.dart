import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final AppBar? appbar;
  final Color? backgroundColor;
  final Widget child;
  final Widget? bottomsheet;

  const DefaultLayout({
    this.appbar,
    this.backgroundColor,
    required this.child,
    this.bottomsheet,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: appbar,
      body: child,
      bottomSheet: bottomsheet,
      resizeToAvoidBottomInset: true,
    );
  }
}
