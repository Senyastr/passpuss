import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LocalizationTool {
  LocalizationTool(this.locale);

  final Locale locale;

  String get forYou {
    return _localizedValues[locale.languageCode]['forYou'];
  }

  String get home {
    return _localizedValues[locale.languageCode]['home'];
  }

  static LocalizationTool of(BuildContext context) {
    return Localizations.of<LocalizationTool>(context, LocalizationTool);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'home': 'Home',
      'forYou': 'For you',
    },
    'ru': {
      'home': 'Главная',
      'forYou': 'Для тебя',
    },
//    'ua':{
//      'home': "Головна",
//      'forYou': 'Для тебе',
//    }
  };
}

class PassPussLocalizationsDelegate
    extends LocalizationsDelegate<LocalizationTool> {
  const PassPussLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ru', 'ua'].contains(locale.languageCode);

  @override
  Future<LocalizationTool> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<LocalizationTool>(LocalizationTool(locale));
  }

  @override
  bool shouldReload(PassPussLocalizationsDelegate old) => false;
}
