import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nexus/ui/screens/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:nexus/utils/my_color.dart';
import 'language_dialog_body.dart';

void showLanguageDialog(String languageList, Locale selectedLocal, BuildContext context, String selectedlanguageCode, {bool fromSplash = false}) {
  var language = jsonDecode(languageList);
  final model = {};

  List  langList = [];

  // if (model.data?.languages != null && model.data!.languages!.isNotEmpty) {
  //   for (var listItem in model.data!.languages!) {
  //     MyLanguageModel model = MyLanguageModel(languageCode: listItem.code ?? '', countryCode: listItem.name ?? '', languageName: listItem.name ?? '');
  //     langList.add(model);
  //   }
  // }

  CustomBottomSheetPlus(
    bgColor: MyColor.getScreenBgColor(),
    isNeedPadding: false,
    child: LanguageDialogBody(
      langList: langList,
      fromSplashScreen: fromSplash,
      selectedlanguageCode: selectedlanguageCode,
    ),
  ).show(context);
}
