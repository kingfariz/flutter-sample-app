import 'package:flutter/material.dart';
import '../themes.dart';

Widget formTextGlobal({required String text}) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: primaryBigTextStyle));
}
