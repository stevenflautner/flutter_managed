import 'package:flutter/material.dart';

extension TextWidget on String {
  Text widget({ TextStyle style }) => Text(this, style: style);
}