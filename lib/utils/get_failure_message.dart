import 'package:flutter/material.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getErrorMessageFromFailure(BuildContext context, Failure error) {
  final locale = AppLocalizations.of(context);
  if (locale == null) {
    return "Error";
  }
  if (error == Failure.noInternetError) {
    return locale.noInternetErrorMsg;
  } else if (error == Failure.networkError) {
    return locale.networkErrorMsg;
  } else if (error == Failure.dbError){
    return locale.cacheErrorMsg;
  } else {
    return locale.unknownErrorMsg;
  }
}