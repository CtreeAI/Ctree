import 'package:flutter/material.dart';

class ViewComponent extends StatelessWidget {
  final Widget child;
  const ViewComponent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            width: 400,
            child: child,
          ),
        ),
      ),
    );
  }
}
