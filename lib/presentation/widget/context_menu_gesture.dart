import 'package:flutter/material.dart';

class ContextMenuGesture extends StatelessWidget {
  final Widget child;
  final GlobalKey menuKey;
  final void Function(Offset childOffset, Size childSize) onShowMenu;
  final VoidCallback onHideMenu;

  const ContextMenuGesture({
    super.key,
    required this.child,
    required this.menuKey,
    required this.onShowMenu,
    required this.onHideMenu,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: menuKey,
      onSecondaryTapUp: (details) {
        final renderBox =
            menuKey.currentContext!.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        onShowMenu(offset, size);
      },
      onTap: onHideMenu,
      child: child,
    );
  }
}
