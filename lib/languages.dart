import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locator.dart';

text(String key) => get<Languages>().current.text(key);

// Service
class Languages {

  CurrentLanguage current;

}

class CurrentLanguage {

  final Locale locale;
  final Map<String, String> _strings;

  CurrentLanguage(this.locale, this._strings);

  String text(String key) => _strings[key];

}

class Localizator extends LocalizationsDelegate<CurrentLanguage> {

  final List<String> supportedCodes;

  Localizator({ @required this.supportedCodes });

  @override
  bool isSupported(Locale locale) => supportedCodes.contains(locale.languageCode);

  @override
  Future<CurrentLanguage> load(Locale locale) async {
    final stored = get<SharedPreferences>().getString("languageCode");
    if (stored != null) locale = Locale(stored);

    final lang = CurrentLanguage(
      locale,
      jsonDecode(
        await rootBundle.loadString('lang/${locale.languageCode}.json')
      )
    );
    get<Languages>().current = lang;

    return lang;
  }

  @override
  bool shouldReload(Localizator old) => false;

  Iterable<Locale> get supportedLocales => supportedCodes.map((code) => Locale(code));

}