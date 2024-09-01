import 'package:flutter/material.dart';
import 'package:graphhooper_route_navigation/graphhooper_route_navigation.dart';

class CustomFloatingActionButton<T> extends StatelessWidget {
  /// Creates [CustomFloatingActionButton] instance
  ///
  const CustomFloatingActionButton({
    super.key,
    required this.heroTag,
    required this.onPressed,
    required this.iconData,
  });

  /// Hero tag id for animation
  ///
  final String heroTag;

  /// On pressed call back
  ///
  final VoidCallback onPressed;

  /// Icon [IconData] for the [FloatingActionButton]
  ///
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: NavigationColors.white,
      shape: RoundedRectangleBorder(
        side:
            const BorderSide(width: 1, color: NavigationColors.boxBorderColor),
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      child: Icon(
        iconData,
        size: 24,
        color: NavigationColors.grey,
      ),
    );
  }
}
