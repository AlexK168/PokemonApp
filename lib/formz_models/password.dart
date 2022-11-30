import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  tooLong,
  noDigits,
  noSpecialChars,
}

class Password extends FormzInput<String, PasswordValidationError> {

  static const _maxLength = 16;
  static const _minLength = 8;

  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  static final RegExp _hasDigitsRegExp = RegExp(r'\d');
  static final RegExp _hasSpecialCharsRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  @override
  PasswordValidationError? validator(String? value) {
    return value == null || value.isEmpty
      ? PasswordValidationError.empty
      : !value.contains(_hasDigitsRegExp) ? PasswordValidationError.noDigits
      : !value.contains(_hasSpecialCharsRegExp) ? PasswordValidationError.noSpecialChars
      : value.length < _minLength ? PasswordValidationError.tooShort
      : value.length > _maxLength ? PasswordValidationError.tooLong
      : null;
  }
}
