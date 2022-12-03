import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailFormField extends StatelessWidget {
  final void Function(String) onChanged;
  final String? errorText;
  const EmailFormField({
    Key? key,
    required this.onChanged,
    required this.errorText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: AppLocalizations.of(context)!.email,
        errorText: errorText
      ),
    );
  }
}
