import 'package:PassPuss/logic/passentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sprintf/sprintf.dart';
import 'localization.dart';

class PassEntryExpiration {
  // by default it's 30 days
  DateTime expirationPeriod;
  PassEntry entry;
  PassEntryExpiration(this.entry, this.expirationPeriod);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // we schedule it here only when we create the passentry
  // we remove schedule when, for instance, we have another schedule for this passEntry(30 days)
  // or we remove, when the passEntry has been removed

  void _init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidInit = AndroidInitializationSettings("ic_logo2");
    var iosInit = IOSInitializationSettings();
    var settings = InitializationSettings(androidInit, iosInit);
    flutterLocalNotificationsPlugin.initialize(settings);
  }
  void scheduleNotification(BuildContext context) async {
    _init();
    var scheduledNotificationDateTime =
        expirationPeriod; //  DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'PassPuss525252',
        'ExpirationPassword2',
        'Here the user will get the notification about expired password.',
    icon: "ic_logo2");
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    var titleText = LocalizationTool.of(context).notificationExpiredTitle;
    var username = entry.getUsername();
    var contentText = sprintf(LocalizationTool.of(context).notificationExpiredContent, [username]); // "The password for %s should be changed."
    await flutterLocalNotificationsPlugin.schedule(
      25,
      titleText,
      contentText,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }
}
