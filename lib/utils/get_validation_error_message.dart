import 'package:flutter/cupertino.dart';
import 'package:pokemon_app/formz_models/password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getPasswordErrorMessage(BuildContext context, PasswordValidationError? error) {
  final locale = AppLocalizations.of(context);
  if (locale == null) {
    return "Error";
  }
  if (error == PasswordValidationError.noSpecialChars) {
    return locale.noSpecialCharsInPassword;
  } else if (error == PasswordValidationError.noDigits) {
    return locale.noDigitsInPassword;
  } else if (error == PasswordValidationError.tooLong){
    return locale.passwordTooLong;
  } else if (error == PasswordValidationError.tooShort){
    return locale.passwordTooShort;
  } else if (error == PasswordValidationError.empty) {
    return locale.passwordEmpty;
  }
  return locale.genericError;
}