import 'package:flutter/material.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getErrorMessageFromFailure(BuildContext context, Failure error) {
  final locale = AppLocalizations.of(context);
  if (locale == null) {
    return "Error";
  }
  switch(error) {
    case Failure.networkError:
      return locale.networkErrorMsg;
    case Failure.dbError:
      return locale.cacheErrorMsg;
    case Failure.unknownError:
      return locale.unknownErrorMsg;
    case Failure.noInternetError:
      return locale.noInternetErrorMsg;
    case Failure.loginError:
      return locale.loginErrorMsg;
    case Failure.invalidEmail:
      return locale.invalidEmailErrorMsg;
    case Failure.userDisabled:
      return locale.userDisabledErrorMsg;
    case Failure.userNotFound:
      return locale.userNotFoundErrorMsg;
    case Failure.wrongPassword:
      return locale.wrongPasswordErrorMsg;
    case Failure.logoutError:
      return locale.logoutErrorMsg;
    case Failure.signUpError:
      return locale.signupErrorMsg;
    default:
      return locale.genericErrorMsg;
  }
}