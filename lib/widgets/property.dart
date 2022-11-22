import 'package:flutter/material.dart';

class Property extends StatelessWidget {
  final Icon leading;
  final String text;
  final TextStyle textStyle;
  const Property({
    Key? key,
    required this.leading,
    required this.text,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leading,
        title: Text(text, style: textStyle,)
      ),
    );
  }
}
