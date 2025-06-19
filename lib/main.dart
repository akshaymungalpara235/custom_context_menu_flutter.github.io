import 'package:custom_context_menu_flutter/presentation/home_page.dart';
import 'package:custom_context_menu_flutter/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  html.document.body!.addEventListener(AppConstants.contextMenu, (event) {
    event.preventDefault();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}
