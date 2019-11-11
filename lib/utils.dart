import 'package:flutter/material.dart';

extension StringText on String {
  Text text({ TextStyle style }) => Text(this, style: style);
}