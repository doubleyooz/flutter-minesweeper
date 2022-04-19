import 'package:flutter/material.dart';
import 'screens/mainPage/menu.dart';

void main() => runApp(
  new MaterialApp(
    builder: (context, child) => new SafeArea(child: child!),
    home: new Home(),
  ),
);

