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

  String get notificationExpiredTitle => getValue("notificationExpiredTitle");

  String get notificationExpiredContent =>
      getValue("notificationExpiredContent");

  String get notifications => getValue("notifications");

  String get newPasswordEmailHint => getValue("newPasswordEmailHint");

  String get newPassswordEmailLabel => getValue("newPassswordEmailLabel");

  String get emailCopied => getValue("emailCopied");

  String get soon => getValue("soon");

  String get emailWarning => getValue("emailWarning");

  String get settingsNotificationPasswordExpirationDays =>
      getValue("settingsNotifcationPasswordExpirationDays");

  String get shareTypeTitleChoice => getValue("shareTypeTitleChoice");

  String get shareTypeImage => getValue("shareTypeImage");

  String get shareTypeText => getValue("shareTypeText");

  String get share => getValue("share");

  String get cancel => getValue("cancel");

  String get privacy => getValue("privacy");

  String get privacySettingsEncryption => getValue("privacySettingsEncryption");

  String get fingerprintAuthentication => getValue("fingerprintAuthentication");

  String get fingerprintStartDialogReason =>
      getValue("fingerprintStartDialogReason");

  String get fingerprintLogin => getValue("fingerprintLogin");

  String get qwertySetting => getValue("qwertySetting");

  String get charsSetting => getValue("charsSetting");

  String get backupFingerprintKeyTitle => getValue("backupFingerprintKeyTitle");

  String get proceed => getValue("proceed");

  String get success => null;

  String get notAuthText => getValue("notAuthText");

  String get typeBackupCode => getValue("typeBackupCode");

  String get fingerprintBackupWindowText =>
      getValue("fingerprintBackupWindowText");

  String get removeEntryFingerprintSetting =>
      getValue("removeEntryFingerprintSetting");

  String get fingerprintAuthRemoveSetup =>
      getValue("fingerprintSettingsChange");

  String get removeEntryFingerprintPrompt =>
      getValue("removeEntryFingerprintPrompt");

  String get onlyLettersSetting => getValue("onlyLettersSetting");

  String get entrySearchHint => getValue("entrySearchHint");

  String get regenerateDialogWarningTitle =>
      getValue("regenerateDialogWarningTitle");

  String get regenerateDialogWarningPositiveAnswer =>
      getValue("regenerateDialogWarningPositiveAnswer");

  String get regenerateDialogWarningContent =>
      getValue("regenerateDialogWarningContent");

  String get sortNone => getValue("sortNone");

  String get sortTime => getValue("sortTime");

  String get regenerateDialogWarningNegativeAnswer =>
      getValue("regenerateDialogWarningNegativeAnswer");

  String get sortTags => getValue("sortTags");

  String get deleteEntryWarningDialogTitle => getValue("deleteEntryWarningDialogTitle");

  String get deleteEntryWarningDialogContent => getValue("deleteEntryWarningDialogContent");

  String get deleteEntryWarningPositiveButton => getValue("deleteEntryWarningPositiveButton");

  String get deleteEntryWarningNegativeButton => getValue("deleteEntryWarningNegativeButton");

  String get googleDriveImportSettingTitle => getValue("googleDriveImportSettingTitle");

  String get import => getValue("import");

  String get export => getValue("export");

  String get data => getValue("data");

  String get autosync => getValue("autoSync"); 

  String get googleDrive => getValue("googleDrive"); 
  

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
      "shareWarningNegative": "No, I want to my mummy.",
      "notificationExpiredTitle": "One of your passwords should be CHANGED",
      "notificationExpiredContent":
          "The password for %s should be changed.", // #SPRINTF
      "notifications": "Notifications",
      "newPasswordEmailHint":
          "The email address connected to this account(optional)",
      "newPassswordEmailLabel":
          "The email address connected to this account(optional)",
      "emailCopied": "Your email has been copied to the clipboard.",
      "soon": "Soon.",
      "emailWarning": "It doesn't seem to be an email.",
      "settingsNotifcationPasswordExpirationDays":
          "The Password Entry expiration time",
      "shareTypeTitleChoice": "Choose how you want to share the account info.",
      "shareTypeImage": "Image",
      "shareTypeText": "Text",
      "share": "Share",
      "cancel": "Cancel",
      "privacy": "Privacy",
      "privacySettingsEncryption": "Keep my passwords encrypted all the time.",
      "fingerprintAuthentication": "Fingerprint Authentication",
      "fingerprintStartDialogReason":
          'Please authenticate in order to turn on/off Fingerprint Authentication',
      "fingerprintLogin": "Please authenticate to see your passwords.",
      "qwertySetting": "Warn me of using a popular password",
      "charsSetting": "Characters allowed for passwords",
      "backupFingerprintKeyTitle": "Save the backup code",
      "proceed": "Continue",
      "notAuthText":
          "Seems like something went wrong. Restart the application or, please, proceed to recover your data.",
      "typeBackupCode": "Please, type down your recovery code. ",
      "fingerprintBackupWindowText":
          "Save the code shown in the middle of the screen. " +
              "Write it down in your notes, take a screenshot. " +
              "If you don't do this, your data might be corrupted and removed.",
      "fingerprintSettingsChange":
          "Scan the fingerprint to verify yourself and make changes to the app that can harm PassPuss' data",
      "removeEntryFingerprintSetting":
          "Always verify the identity when removing password entries",
      "removeEntryFingerprintPrompt":
          "Are you sure about removing the password entry? If so, scan your fingerprint.",
      "onlyLettersSetting": "Warn of using only letters in the password",
      "entrySearchHint": "Search an entry",
      "regenerateDialogWarningTitle":
          "Are you sure you want to regenerate password?",
      "regenerateDialogWarningPositiveAnswer": "Yes, I'm ready",
      "regenerateDialogWarningNegativeAnswer": "No, let me go back",
      "regenerateDialogWarningContent":
          "Regenerating password is going to REMOVE the old password and replace it with the new one!" +
              " Back up the old password.",
      "sortNone": "None",
      "sortTime" : "By time",
      "sortTags" : "By tags",
      "deleteEntryWarningDialogTitle" : "You are trying to remove an entry",
      "deleteEntryWarningPositiveButton" : "Yep, we're good to go.",
      "deleteEntryWarningNegativeButton" : "Nope, get back",
      "deleteEntryWarningDialogContent" : "Are you sure about removing the password entry?",
      "googleDriveImportSettingTitle" : "Import data from Google Drive",
      "import" : "Import",
      "data" : "Data",
      "export" : "Export",
      "autoSync": "Automatic synchronization",
      "googleDrive" : "Google Drive"
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
      "shareWarningNegative": "Нет, я хочу к маме.",
      "notificationExpiredTitle": "Один с ваших паролей следует СМЕНИТЬ",
      "notificationExpiredContent": "Пароль к %s следует сменить", // #SPRINTF
      "notifications": "Уведомления",
      "newPasswordEmailHint": "Email связаный с этим аккаунтом(по желанию)",
      "newPassswordEmailLabel": "Email связаный с этим аккаунтом(по желанию)",
      "emailCopied": "Емейл скопирован в буфер обмена.",
      "soon": "Скоро.",
      "emailWarning": "Кажется это не емейл.",
      "settingsNotifcationPasswordExpirationDays":
          "Истечение срока действия пароля",
      "shareTypeTitleChoice":
          "Выберите как вы хотите поделится данными от аккаунта",
      "shareTypeImage": "Фото",
      "shareTypeText": "Текст",
      "share": "Поделиться",
      "cancel": "Отменить",
      "privacy": "Приватность",
      "privacySettingsEncryption": "Хранить пароли зашифроваными",
      "fingerprintAuthentication": "Верификация по отпечатку пальца.",
      "fingerprintStartDialogReason":
          "Пожалуйста, прикоснитесь к сканеру, чтобы включить/выключить аутентификацию.",
      "fingerprintLogin":
          "Пожалуйста, прикоснитесь к сканеру, чтобы увидеть свои пароли",
      "qwertySetting": "Предупредить о использовании популярных паролей",
      "charsSetting": "Кол-во символов разрешенных для паролей",
      "backupFingerprintKeyTitle": "Сохраните код восстановления паролей",
      "proceed": "Продолжить",
      "notAuthText":
          "Похоже что то пошло не те так. Перезагрузите приложение. Следуйте дальше для восстановления данных.",
      "typeBackupCode": "Пожалуйста, напишите пароль восстановления данных. ",
      "fingerprintBackupWindowText":
          "Сохраните код, который находится по середине екрана. " +
              "Запишите его в заметках, сделайте скриншот. " +
              "Если вы откажетесь делать это, есть вероятность, что вы потеряете данные.",
      "fingerprintSettingsChange":
          "Просканируйте отпечаток пальца, чтобы удостовериться в вашей личности и ввести изменения в Pass Puss, " +
              "которые могут нанести вред вашим данным.",
      "removeEntryFingerprintSetting":
          "Всегда удостовериваться в личности при удалении записей паролей.",
      "removeEntryFingerprintPrompt":
          "Вы уверенны, что хотите удалить запись пароля? Если да, просканируйте отпечаток пальца.",
      "onlyLettersSetting": "Предупредить о использовании только букв в пароле.",
      "entrySearchHint": "Искать запись",
      "regenerateDialogWarningTitle":
          "Вы уверенны, что хотите сгенерировать пароль и заменить старый?",
      "regenerateDialogWarningPositiveAnswer": "Да, я готов",
      "regenerateDialogWarningNegativeAnswer": "Нет, верните меня назад",
      "regenerateDialogWarningContent":
          "Регенерация пароля УДАЛИТ ваш старый пароль и заменит его другим! " +
              "Сохраните старый пароль.",
      "sortNone": "Отсутствует",
      "sortTime" : "По времени",
      "sortTags" : "По тегам",
      "deleteEntryWarningDialogTitle" : "Вы пытаетесь удалить запись пароля",
      "deleteEntryWarningPositiveButton" : "Да, погнали",
      "deleteEntryWarningNegativeButton" : "Нет, давайте назад",
      "deleteEntryWarningDialogContent" : "Вы уверенны, что хотите удалить запись пароля?",
      "googleDriveImportSettingTitle" : "Импорт с Google Диска",
      "import" : "Импорт",
      "data" : "Данные",
      "export" : "Экспорт",
      "autoSync": "Автоматическая синхронизация",
      "googleDrive" : "Google Диск"
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
      "shareWarningNegative": "Ні, я хочу до матусі.",
      "notificationExpiredTitle": "Один з ваших паролів слід ЗМІНИТИ",
      "notificationExpiredContent": "Пароль до %s слід змінити", // #SPRINTF
      "notifications": "Сповіщення",
      "newPasswordEmailHint": "Емейл зв'язаний з акаунтом.",
      "newPassswordEmailLabel": "Емейл зв'язаний з акаунтом.",
      "emailCopied": "Емейл був зкопійований в буфер обміну.",
      "soon": "Скоро",
      "emailWarning": "Здається це не пароль.",
      "settingsNotifcationPasswordExpirationDays":
          "Закінчується термін придатності пароля",
      "shareTypeTitleChoice":
          "Виберіть як ви хочете поділитися даними акаунту.",
      "shareTypeImage": "Фото",
      "shareTypeText": "Текст",
      "share": "Поширити",
      "cancel": "Відхилити",
      "privacy": "Privacy",
      "privacySettingsEncryption": "Зберігати паролі зашифрованими",
      "fingerprintAuthentication": "Верифікація по відбитку пальця",
      "fingerprintStartDialogReason":
          "Будь ласка, доторкніться до сканеру, щоб ввімкнути/вимкнути аутентифікацію по відбитку пальця.",
      "fingerprintLogin":
          "Будь ласка, доторкніться до сканеру, щоб побачити свої паролі.",
      "qwertySetting": "Попередити про використання популярних паролей",
      "charsSetting": "Кількість символів дозволених для паролей",
      "backupFingerprintKeyTitle": "Збережіть код для відновлення паролей",
      "proceed": "Продовжити",
      "notAuthText":
          "Схоже щось пішло не так. Перезапустіть додаток або слідуйте далі, щоб відновити дані.",
      "typeBackupCode": "Будь ласка, напишіть пароль для відновлення даних",
      "fingerprintBackupWindowText":
          "Збережіть код, який знаходиться по середині екрану."
                  "Save the code shown in the middle of the screen. " +
              "Запишіть його в нотатках, зробіть знімок екрану. " +
              "Якщо ви відмовитесь зробити це, є можливість, що ваші дані загубляться.",
      "fingerprintSettingsChange":
          "Проскануйте відбиток пальца, щоб запевнитись у вашій особі " +
              "та ввести зміни до Pass Puss, які можуть нанести шкоду вашим даним.",
      "removeEntryFingerprintSetting":
          "Завжди запевнятися в особі при видаленні записів паролей",
      "removeEntryFingerprintPrompt":
          "Ви впевнені, що хочете видалити запис паролю? Якщо так, то проскануйте відбиток пальца.",
      "onlyLettersSetting": "Попередити про використання тільки букв в паролі.",
      "entrySearchHint": "Шукати запис",
      "regenerateDialogWarningTitle":
          "Ви впевнені, що хочете регенерувати пароль?",
      "regenerateDialogWarningPositiveAnswer": "Так, я готовий",
      "regenerateDialogWarningNegativeAnswer": "Ні, поверніть мене назад",
      "regenerateDialogWarningContent":
          "Регенерація пароля ВИДАЛИТЬ ваш стаарий пароль та замінить його новим!" +
              "Збережіть свій старий пароль.",
      "sortNone": "Відсутнє",
      "sortTime" : "За часом",
      "sortTags" : "За тегами",
      "deleteEntryWarningDialogTitle" : "Ви намагаєтесь видалити запис паролю",
      "deleteEntryWarningPositiveButton" : "Так, полетіли",
      "deleteEntryWarningNegativeButton" : "Ні, давайте назад",
      "deleteEntryWarningDialogContent" : "Ви впевнені, що хочете видалити запис паролю?",
      "googleDriveImportSettingTitle" : "Імпорт з Google Диску",
      "import" : "Імпорт",
      "data" : "Дані",
      "export" : "Експорт",
      "autoSync" : "Автоматична синхронізація",
      "googleDrive" : "Google Диск"
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
