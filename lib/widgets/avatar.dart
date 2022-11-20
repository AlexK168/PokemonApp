import 'package:flutter/material.dart';
import '../utils/show_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Avatar extends StatefulWidget {
  final String url;
  const Avatar({Key? key, required this.url}) : super(key: key);

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _imageError = false;
  @override
  Widget build(BuildContext context) {
    if (_imageError) {
      return const Icon(
        Icons.question_mark,
        size: 140,
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(widget.url),
      radius: 70,
      onBackgroundImageError: (_, __) {
        showSnackBar(
          context, AppLocalizations.of(context)!.pictureLoadError
        );
        setState(() {
          _imageError = true;
        });
      },
    );
  }
}
