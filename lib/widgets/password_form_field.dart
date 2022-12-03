import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordFormField extends StatelessWidget {
  final void Function(String) onChanged;
  final void Function()? onVisibilityToggle;
  final bool isObscure;
  final String? errorText;
  const PasswordFormField({
    Key? key,
    required this.onChanged,
    required this.errorText,
    required this.isObscure,
    this.onVisibilityToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: isObscure,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: onVisibilityToggle != null
          ? IconButton(
            icon: !isObscure
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: onVisibilityToggle,
          )
          : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: AppLocalizations.of(context)!.password,
        errorText: errorText,
      ),
    );
  }
}
