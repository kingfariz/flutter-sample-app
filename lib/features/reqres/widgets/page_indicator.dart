import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int activePage;
  final bool darkMode;
  const PageIndicator(
      {super.key, required this.activePage, this.darkMode = true});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: darkMode
                ? (Colors.white
                    .withOpacity(index == (activePage - 1) ? 1 : 0.56))
                : (index == (activePage - 1)
                    ? const Color.fromRGBO(18, 26, 28, 1)
                    : const Color.fromRGBO(151, 154, 155, 1)),
          ),
        ),
      ),
    );
  }
}
