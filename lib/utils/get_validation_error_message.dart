import 'package:flutter/cupertino.dart';
import 'package:pokemon_app/formz_models/password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getPasswordErrorMessage(BuildContext context, PasswordValidationError? error) {
  final locale = AppLocalizations.of(context);
  if (locale == null) {
    return "Error";
  }
  switch(error) {
    case PasswordValidationError.empty:
      return locale.passwordEmpty;
    case PasswordValidationError.tooShort:
      return locale.passwordTooShort;
    case PasswordValidationError.tooLong:
      return locale.passwordTooLong;
    case PasswordValidationError.noDigits:
      return locale.noDigitsInPassword;
    case PasswordValidationError.noSpecialChars:
      return locale.noSpecialCharsInPassword;
    default:
      return locale.genericErrorMsg;
  }
}