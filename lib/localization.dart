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
    return getValue('passwordRepeatChars');
  }

  String get passwordIdiot {
    return getValue('passwordIdiot');
  }

  String get passwordLetters {
    return getValue('passwordLetters');
  }

  String get passwordNumbers {
    return getValue('passwordNumbers');
  }

  String get createNewPassword {
    return getValue('createNewPassword');
  }

  get newPasswordUsernameHint => getValue('newPasswordUsernameHint');

  get newPasswordUsernameLabel => getValue('newPasswordUsernameLabel');

  get newPasswordMore8Chars => getValue('newPasswordMore8Chars');

  get newPasswordFormHint => getValue('newPasswordFormHint');

  get password => getValue('password');

  get newPasswordTitleNotEmpty => getValue("newPasswordTitleNotEmpty");

  get newPasswordTitleHint => getValue('newPasswordTitleHint');

  get title => getValue("title");

  String get passwordCopied => getValue("passwordCopied");

  get passwordGenSelect => getValue("passwordGenSelect");

  String get passwordDetailsPage => getValue("passwordDetailsPage");

  String get details => getValue("details");

  String get time => getValue("time");

  String get usernameCopied => getValue("usernameCopied");

  String get passEntriesEmpty => getValue("passwordEmpty");

  String get recommendationEmpty => getValue("recommendationEmpty");

  String get editPasswordPage => getValue("editPasswordPage");

  String get settings => getValue("settings");

  String get aboutApp => getValue("aboutApp");

  get shareWarningTitle => getValue("shareWarningTitle");

  String get shareWarningContent => getValue("shareWarningContent");

  String get shareWarningPositive => getValue("shareWarningPositive");

  String get shareWarningNegative => getValue("shareWarningNegative");

  String getValue(String key) {
    return _localizedValues[locale.languageCode][key];
  }

  String get usernameBlank {
    return getValue("usernameBlank");
  }

  static LocalizationTool of(BuildContext context) {
    return Localizations.of<LocalizationTool>(context, LocalizationTool);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'home': 'Home',
      'forYou': 'For you',
      'password': "Password",
      'title': 'Title',
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
      'createNewPassword': "Create new password entry",
      'usernameBlank': "Username shouldn't be blank",
      'newPasswordUsernameHint': "Your username/email/login",
      'newPasswordUsernameLabel': "Username/email/login",
      'newPasswordMore8Chars': 'Password should have more than 8 characters',
      'newPasswordFormHint': "Your super-secure password",
      'newPasswordTitleNotEmpty': "Title shouldn't be empty.",
      'newPasswordTitleHint': "Write something specific to this entry",
      'passwordCopied': "Your password has been copied to the clipboard.",
      'passwordGenSelect':
          "Select how many characters your password is going to consist of.",
      "passwordDetailsPage": "Password Details",
      "details": "Details",
      "time": "Time",
      "usernameCopied": "The username has been copied to the clipboard.",
      "passwordEmpty": "There are no password entries. Fill in some passwords.",
      "recommendationEmpty": "Your passwords are completely secure.",
      "editPasswordPage": "Edit password",
      "settings": "Settings",
      "aboutApp": "About",
      "shareWarningTitle": "Are you sure about sharing your password?",
      "shareWarningContent":
          "Sharing your password with other people is UNSAFE. " +
              "Our app strictly doesn't recommend you to do so.",
      "shareWarningPositive": "Yes, I'm risky.",
      "shareWarningNegative": "No, I want to my mummy."
    },
    'ru': {
      'home': 'Главная',
      'forYou': 'Для тебя',
      'password': "Пароль",
      'title': 'Заголовок',
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
          "Этот пароль содержит только цифры. Подумайте сгенерировать другой.",
      'createNewPassword': "Создать новую запись пароля.",
      'usernameBlank': 'Имя пользователя не должно быть пустым.',
      'newPasswordUsernameHint': "Ваше имя пользователя/email/login",
      'newPasswordUsernameLabel': 'Имя пользователя/email/login',
      'newPasswordMore8Chars': 'Пароль должен содержать > чем 8 символов',
      'newPasswordFormHint': "Ваш очень безопасный пароль",
      'newPasswordTitleNotEmpty': 'Заголовок не должен быть пустой',
      'newPasswordTitleHint': "Напишите что-то связаное с этим паролем.",
      'passwordCopied': "Пароль скопирован в буфер обмена.",
      'passwordGenSelect':
          "Выберите со сколько символов будет складатся Ваш пароль",
      "passwordDetailsPage": "О пароле",
      "details": "Подробнее",
      "time": 'Время',
      "usernameCopied": "Имя пользователя скопировано в буфер обмено.",
      "passwordEmpty": "Записи паролей отсутсвуют. Заполните несколько.",
      "recommendationEmpty": "Ваши пароли в безопасности.",
      "editPasswordPage": "Редактировать пароль",
      "settings": "Настройки",
      "aboutApp": "Об приложении",
      "shareWarningTitle": "Вы уверенны, что хотите отправить пароль?",
      "shareWarningContent":
          "Делиться паролем НЕБЕЗОПАСНО. Мы Вам насоятельно рекомендуем воздержатся от этого.",
      "shareWarningPositive": "Да, я опасный.",
      "shareWarningNegative": "Нет, я хочу к маме."
    },
    'ua': {
      'home': "Головна",
      'forYou': 'Для тебе',
      'password': 'Пароль',
      'title': 'Заголовок',
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
          "Цей пароль містить тільки цифри. Подумайте згенерувати інший.",
      "createNewPassword": "Створити новий запис пароля.",
      "usernameBlank": "Ім'я користувача не має бути порожнім.",
      'newPasswordUsernameHint': "Ваше ім'я користувача/email/login",
      'newPasswordUsernameLabel': "Ім'я користувача/email/login",
      'newPasswordMore8Chars':
          "Новий пароль має містити більше ніж 8 символів.",
      'newPasswordFormHint': "Ваш дуже захищиний пароль",
      'newPasswordTitleNotEmpty': "Заголовок не має бути пустим",
      'newPasswordTitleHint': "Напишіть щось пов'язане з цим паролем.",
      'passwordCopied': "Пароль був зкопійований в буфер обміну.",
      'passwordGenSelect':
          "Виберіть зі скільки символів буде складатися Ваш пароль.",
      "passwordDetailsPage": "Про пароль",
      "details": "Деталі",
      "time": "Час",
      "usernameCopied": "Ім'я користувача було зкопійовано в буфер обмена.",
      "passwordEmpty": "Записи паролей відсутні. Створіть декілька.",
      "recommendationEmpty": "Ваші паролі в безпеці.",
      "editPasswordPage": "Редагувати пароль",
      "settings": "Налаштування",
      "aboutApp": "Про додаток",
      "shareWarningTitle": "Ви впевнені, що хочете відправити пароль?",
      "shareWarningContent":
          "Поширити пароль занадто НЕБЕЗПЕСНО. Ми Вам не рекомендуємо відправляти пароль.",
      "shareWarningPositive": "Так, я небезпечний.",
      "shareWarningNegative": "Ні, я хочу до матусі."
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
