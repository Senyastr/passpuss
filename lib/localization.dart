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

  String get passwordExpired {
    return _localizedValues[locale.languageCode]['passwordExpired'];
  }

  String get passwordChars {
    return _localizedValues[locale.languageCode]['passwordChars'];
  }

  String get passwordRepeatChars {
    return _localizedValues[locale.languageCode]['passwordRepeatChars'];
  }

  String get passwordIdiot {
    return _localizedValues[locale.languageCode]['passwordIdiot'];
  }

  String get passwordLetters {
    return _localizedValues[locale.languageCode]['passwordLetters'];
  }

  String get passwordNumbers{
    return _localizedValues[locale.languageCode]['passwordNumbers'];
  }

  static LocalizationTool of(BuildContext context) {
    return Localizations.of<LocalizationTool>(context, LocalizationTool);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'home': 'Home',
      'forYou': 'For you',
      'passwordExpired':
          "You should consider generating another password for this entry.",
      'passwordChars':
          "This password has length less than 8 characters long. Generate another one.",
      'passwordRepeatChars':
          "This password has repeated characters. Generate another one.",
      "passwordIdiot":
          "This password is widely used in the Internet and can be brute-forced. "
              "You should generate another one",
      "passwordLetters":
          "This password contains letters only. Consider generating a new one.",
      "passwordNumbers":
          "This password contains numbers only. Consider generating a new one.",
    },
    'ru': {
      'home': 'Главная',
      'forYou': 'Для тебя',
      'passwordExpired': "Лучше подумать о генерировании нового пароля.",
      'passwordChars':
          "Этот пароль содержит менше чем 8 символов. Сгенерируйте другой.",
      'passwordRepeatChars':
          "Этот пароль содержит символы, которые повторяються. Сгенерируйте другой.",
      'passwordIdiot':
          "Этот пароль используется в Интернете и его легко угадать. Стоит сгенерировать другой.",
      "passwordLetters":
          "Этот пароль содержит только буквы. Подумайте сгенерировать другой.",
      "passwordNumbers":
          "Этот пароль содержит только цифры. Подумайте сгенерировать другой."
    },
    'ua': {
      'home': "Головна",
      'forYou': 'Для тебе',
      'passwordExpired': "Рекомендується подумати про зміну паролю.",
      "passwordChars":
          "Цей пароль містить менше ніж 8 символів. Згенеруйте інакший.",
      "passwordRepeatChars":
          "Цей пароль містить символи, які повторюються. Згенеруйте інакший.",
      "passwordIdiot":
          "Цей пароль широко використовується в Інтернеті та його легко вгадати. "
              "Задумайте про генерацію нового.",
      "passwordLetters":
          "Цей пароль містить тільки букви. Подумайте згенерувати інший.",
      "passwordNumbers":
          "Цей пароль містить тільки цифри. Подумайте згенерувати інший."
    }
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
