import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locator.dart';

text(String key) => get<Lang>().text(key);

class Lang {

  final Locale locale;
  Map<String, String> _strings;

  Lang(this.locale, this._strings);

  String text(String key) => _strings[key];

  void change(String local) {


  }

//  static Lang of(BuildContext context) => Localizations.of<Lang>(context, Lang);

  static LocalizationsDelegate<Lang> register(List<String> supported)
    => AppLocalizationsDelegate(supported);

}

class AppLocalizationsDelegate extends LocalizationsDelegate<Lang> {

  final List<String> supportedCodes;

  AppLocalizationsDelegate(this.supportedCodes);

  @override
  bool isSupported(Locale locale) => supportedCodes.contains(locale.languageCode);

  @override
  Future<Lang> load(Locale locale) async {
    final stored = get<SharedPreferences>().getString("languageCode");
    if (stored != null) locale = Locale(stored);

    final lang = Lang(
      locale,
      jsonDecode(
          await rootBundle.loadString('lang/${locale.languageCode}.json')
      )
    );
    get.registerSingleton(lang);
    return lang;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  Iterable<Locale> get supportedLocales => supportedCodes.map((code) => Locale(code));

}