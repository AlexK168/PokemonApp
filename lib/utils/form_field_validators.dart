String? passwordValidator(String? value) {
  if (value == null) {
    return "Password can't be empty";
  }
  if (value.length < 8) {
    return "Password has to be at least 8 characters long";
  } else {
    return null;
  }
}

final RegExp emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$"
);

String? emailValidator(String? value) {
  if (value == null) {
    return "Email can't be empty";
  }
  if (emailRegExp.hasMatch(value)) {
    return null;
  } else {
    return "Email is invalid";
  }
}