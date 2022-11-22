import 'package:flutter/material.dart';

class TypeWidget extends StatelessWidget {
  final String imgUrl;
  final String type;
  final TextStyle textStyle;
  const TypeWidget({
    Key? key,
    required this.imgUrl,
    required this.type,
    required this.textStyle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(35)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              imgUrl,
            ),
          ),
          const SizedBox(width: 8,),
          Text(
            type,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
