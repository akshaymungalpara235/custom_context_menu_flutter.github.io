import 'package:custom_context_menu_flutter/presentation/widget/context_menu_widget.dart';
import 'package:custom_context_menu_flutter/presentation/widget/rectangale_area_widget.dart';
import 'package:custom_context_menu_flutter/utils/app_strings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  OverlayEntry? _overlayEntry;
  Offset? _menuOffset;
  Size? _childSize;
  GlobalKey? _lastMenuKey;

  // Stable keys for each menu child
  final keyTopLeft = GlobalKey();
  final keyTopRight = GlobalKey();
  final keyBottomRight = GlobalKey();
  final keyBottomLeft = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _hideMenu();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // On resize, recalculate the child position and size if menu is open
    if (_overlayEntry != null && _lastMenuKey != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _lastMenuKey!.currentContext;
        if (context != null) {
          final renderBox = context.findRenderObject() as RenderBox;
          final offset = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          _showMenu(offset, size, key: _lastMenuKey);
        }
      });
    }
  }

  void _showMenu(Offset childOffset, Size childSize, {GlobalKey? key}) {
    _hideMenu();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const menuWidth = 150.0;
    const menuHeight = 150.0;

    // Prefer to show menu to the right of the child, else to the left
    double x = childOffset.dx + childSize.width;
    if (x + menuWidth > screenWidth) {
      x = childOffset.dx - menuWidth;
      if (x < 0) x = 0;
    }
    // Prefer to show menu aligned to top of child, else move up
    double y = childOffset.dy;
    if (y + menuHeight > screenHeight) {
      y = screenHeight - menuHeight;
      if (y < 0) y = 0;
    }

    _menuOffset = childOffset;
    _childSize = childSize;
    if (key != null) _lastMenuKey = key;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
        top: y,
        left: x,
        child: SizedBox(
          width: menuWidth,
          child: Material(
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(title: const Text(AppStrings.create), onTap: _hideMenu),
                ListTile(title: const Text(AppStrings.edit), onTap: _hideMenu),
                ListTile(title: const Text(AppStrings.remove), onTap: _hideMenu),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _menuOffset = null;
    _childSize = null;
    _lastMenuKey = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _hideMenu,
            child: Stack(
              children: [
                Positioned(
                  left: constraints.maxWidth / 6,
                  top: constraints.maxHeight / 6,
                  child: ContextMenu(
                    menuKey: keyTopLeft,
                    onShowMenu:
                        (offset, size) =>
                        _showMenu(offset, size, key: keyTopLeft),
                    onHideMenu: _hideMenu,
                    child: RectangleArea(
                      label: AppStrings.topLeft,
                      color: Colors.yellow,
                      size: constraints.biggest.shortestSide / 4,
                    ),
                  ),
                ),
                Positioned(
                  right: constraints.maxWidth / 6,
                  top: constraints.maxHeight / 6,
                  child: ContextMenu(
                    menuKey: keyTopRight,
                    onShowMenu:
                        (offset, size) =>
                        _showMenu(offset, size, key: keyTopRight),
                    onHideMenu: _hideMenu,
                    child: RectangleArea(
                      label: AppStrings.topRight,
                      color: Colors.green,
                      size: constraints.biggest.shortestSide / 4,
                    ),
                  ),
                ),
                Positioned(
                  right: constraints.maxWidth / 6,
                  bottom: constraints.maxHeight / 6,
                  child: ContextMenu(
                    menuKey: keyBottomRight,
                    onShowMenu:
                        (offset, size) =>
                        _showMenu(offset, size, key: keyBottomRight),
                    onHideMenu: _hideMenu,
                    child: RectangleArea(
                      label: AppStrings.bottomRight,
                      color: Colors.blue,
                      size: constraints.biggest.shortestSide / 4,
                    ),
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth / 6,
                  bottom: constraints.maxHeight / 6,
                  child: ContextMenu(
                    menuKey: keyBottomLeft,
                    onShowMenu:
                        (offset, size) =>
                        _showMenu(offset, size, key: keyBottomLeft),
                    onHideMenu: _hideMenu,
                    child: RectangleArea(
                      label: AppStrings.bottomLeft,
                      color: Colors.purple,
                      size: constraints.biggest.shortestSide / 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
