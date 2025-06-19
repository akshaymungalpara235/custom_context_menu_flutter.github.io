
import 'package:custom_context_menu_flutter/presentation/widget/interceptor_widget.dart';
import 'package:custom_context_menu_flutter/presentation/widget/context_menu_gesture.dart';
import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  final Widget child;
  final GlobalKey menuKey;
  final void Function(Offset childOffset, Size childSize) onShowMenu;
  final VoidCallback onHideMenu;

  const ContextMenu({
    super.key,
    required this.child,
    required this.menuKey,
    required this.onShowMenu,
    required this.onHideMenu,
  });

  @override
  Widget build(BuildContext context) {
    return InterceptorWidget(
      child: ContextMenuGesture(
        menuKey: menuKey,
        onShowMenu: onShowMenu,
        onHideMenu: onHideMenu,
        child: child,
      ),
    );
  }
}