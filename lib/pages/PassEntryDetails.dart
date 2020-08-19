import 'dart:io';

import 'package:PassPuss/pages/editEntryPage.dart';
import 'package:PassPuss/pages/homePage.dart';
import 'package:PassPuss/pages/settings/ForYou.dart';
import 'package:PassPuss/pages/settings/settings.dart';
import 'package:PassPuss/passentry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:PassPuss/message.dart';
import 'package:PassPuss/localization.dart';

import '../Database.dart';
import '../NewPassEntry.dart';
import '../PassFieldItem.dart';
import '../main.dart';
import '../notifications.dart';

class PassEntryDetails extends StatefulWidget {
  PassEntry entry;

  @override
  State<StatefulWidget> createState() {
    return PassEntryDetailsState(entry);
  }

  PassEntryDetails(this.entry);
}

class PassEntryDetailsState extends State<PassEntryDetails> {
  PassEntry entry;
  Widget mainInfo;
  Widget timeBlock;

  Icon iconLocked;
  Icon iconOpened;

  var passwordShowState;
  var passwordStateKey = GlobalKey();
  var isPasswordShown = false;
  var username;
  var password;
  var email;
  var expiration;
  Tags tag;
  DateFormat timeCreated;
  PassEntryDetailsState state;

  var id;

  @override
  void initState() {
    super.initState();
    username = entry.getUsername();
    password = entry.getPassword();
    email = entry.getEmail();
    tag = entry.tag;
    id = entry.id;
    state = this;
  }

  var _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    Widget shotItem = Container(
        width: 400,
        height: 200,
        child: PassField(entry, GlobalKey())); // remove optionally
    timeCreated = DateFormat(DateFormat.YEAR_MONTH_DAY,
            LocalizationTool.of(context).locale.toLanguageTag())
        .add_Hm();
    passwordShowState = Icon(Icons.lock,
        key: passwordStateKey, color: Theme.of(context).accentColor);
    iconLocked = Icon(Icons.lock,
        key: passwordStateKey, color: Theme.of(context).accentColor);
    iconOpened = Icon(Icons.lock_open,
        key: passwordStateKey, color: Theme.of(context).accentColor);

    mainInfo = Column(children: <Widget>[
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                LocalizationTool.of(context).details,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ))),
      Align(
        alignment: Alignment.topLeft,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Hero(
                    tag: "entryIcon$id",
                    child: SvgPicture.asset(entry.getIconId()),
                  ),
                ),
                Text(entry.getTitle(),
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ]),
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: TagHelper.widgetByTag(entry.tag)),
            ]),
      ),
      Align(
          alignment: Alignment.bottomLeft,
          child: Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
              child: Icon(Icons.person, color: Theme.of(context).accentColor),
            ),
            Padding(
                child: Text(username,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 18)),
            Padding(
                padding: EdgeInsets.all(1),
                child: IconButton(
                    icon: Icon(Icons.content_copy,
                        color: Theme.of(context).accentColor),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: username));
                      PassEntriesPage.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                              content: Text(LocalizationTool.of(context)
                                  .usernameCopied)));
                    })),
            Icon(
              Icons.text_rotation_none,
              color: Theme.of(context).accentColor,
            ),
            Padding(
                padding: EdgeInsets.all(3),
                child: Text(username.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white)))
          ])),
      Align(
        alignment: Alignment.bottomLeft,
        child: Row(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
              child: IconButton(
                icon: (isPasswordShown) ? iconOpened : iconLocked,
                onPressed: () {
                  setState(() {
                    isPasswordShown = !isPasswordShown;
                  });
                },
              )),
          Padding(
              padding: EdgeInsets.only(
                left: 6,
                top: 10,
                bottom: 10,
              ),
              child: Text((isPasswordShown) ? password : hidePassword(password),
                  style: TextStyle(fontSize: 20, color: Colors.white))),
          Padding(
              padding: EdgeInsets.all(1),
              child: IconButton(
                  icon: Icon(Icons.content_copy,
                      color: Theme.of(context).accentColor),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: password));
                    PassEntriesPage.scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                            content: Text(
                                LocalizationTool.of(context).passwordCopied)));
                  })),
          Icon(
            Icons.text_rotation_none,
            color: Theme.of(context).accentColor,
          ),
          Padding(
              padding: EdgeInsets.all(3),
              child: Text(password.length.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white))),
        ]),
      ),
      Align(
          alignment: Alignment.bottomLeft,
          child: Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
              child: Icon(Icons.email, color: Theme.of(context).accentColor),
            ),
            Padding(
                child: Text(email,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 18)),
            Padding(
                padding: EdgeInsets.all(1),
                child: IconButton(
                    icon: Icon(Icons.content_copy,
                        color: Theme.of(context).accentColor),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: email));
                      PassEntriesPage.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                              content: Text(
                                  LocalizationTool.of(context).emailCopied)));
                    })),
            Icon(
              Icons.text_rotation_none,
              color: Theme.of(context).accentColor,
            ),
            Padding(
                padding: EdgeInsets.all(3),
                child: Text(email.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white)))
          ])),
    ]);
    timeBlock = Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  LocalizationTool.of(context).time,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                )),
          ),
          AlignCenterLeft(
              Row(children: <Widget>[
                Icon(Icons.edit, color: Theme.of(context).accentColor),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(timeCreated.format(entry.createdTime),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white)),
                )
              ]),
              EdgeInsets.only(
                left: 20,
                top: 10,
              ))
        ]));
    var editButton = FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => EditEntryPage(entry)));
        },
        child: Icon(Icons.edit));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: Theme.of(context).accentColor,
              ),
              onPressed: _share,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).cardColor,
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    LocalizationTool.of(context).passwordDetailsPage,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.white),
                  )),
            ),
            Screenshot(
                controller: screenshotController,
                child:
                    Card(color: Theme.of(context).cardColor, child: mainInfo)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.white),
            ),
            timeBlock,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.white),
            ),
            Align(
                alignment: Alignment.center,
                child: IconButton(
                    icon: Icon(Icons.lightbulb_outline),
                    iconSize: 52,
                    color: Colors.yellow,
                    onPressed: () {
                      tryRegeneratePassword(context,
                          onPositive: regeneratePassword,
                          onNegative: cancelPasswordRegeneration);
                    })),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10),
                child:
                    Align(alignment: Alignment.bottomRight, child: editButton),
              ),
            ),
          ],
        )));
  }

  PassEntryDetailsState(this.entry);

  Widget AlignCenterLeft(Widget text, EdgeInsets insets) {
    return Padding(
      padding: insets,
      child: Align(alignment: Alignment.centerLeft, child: text),
    );
  }

  var screenshotController = ScreenshotController();

  void _share() {
    // depces:
    // esys_flutter_share
    // screenshot

    showDialog(
        context: _context,
        builder: (context) => AlertDialog(
              title: Text(
                LocalizationTool.of(context).shareWarningTitle,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                  LocalizationTool.of(context).shareWarningContent,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.white),
                ),
                Icon(
                  Icons.warning,
                  color: Colors.redAccent,
                  size: 100,
                ),
              ]),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                      LocalizationTool.of(context)
                          .shareWarningPositive, // Yes, I'm risky.
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.lightGreenAccent)),
                  onPressed: () {
                    setState(() {
                      isPasswordShown = true;
                    });
                    Navigator.pop<AlertDialog>(_context);

                    showDialog(
                      context: _context,
                      builder: (context) => ChooseShareTypeDialog(
                          entry, screenshotController, state),
                    );
                    // screenshotController
                    //     .capture(pixelRatio: 8)
                    //     .then((File image) async {
                    //   await Share.file(entry.getUsername(), "password.png",
                    //       await image.readAsBytes(), 'image/png');
                    //   setState(() {
                    //     isPasswordShown = false;
                    //   });
                    // });
                  },
                ),
                FlatButton(
                  child: Text(
                      LocalizationTool.of(context)
                          .shareWarningNegative, // "No, I want to my mummy."
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.redAccent)),
                  onPressed: () {
                    Navigator.pop<AlertDialog>(_context);
                  },
                ),
              ],
            ));

    removeShareFile();
  }

  void removeShareFile() {}

  void tryRegeneratePassword(BuildContext context,
      {VoidCallback onPositive, VoidCallback onNegative}) {
    var positive = onPositive == null ? () {} : onPositive;
    var negative = onNegative == null ? () {} : onNegative;
    showDialog(
        context: context,
        builder: (context) => RegeneratePasswordDialog(
              onPositive: positive,
              onNegative: negative,
            ));
  }

  void regeneratePassword() async {
    Navigator.pop<RegeneratePasswordDialog>(context);
    var dialog = ResultDialog("message");
    showDialog(context: context, builder: (context) => dialog);
    var temp =
        (await SettingsManager.getPref(ForYouSettingsTabState.charsAllowedKey)
            as int);
    var minChars = temp == null ? 8 : temp;
    var username = entry.getUsername();
    var password = PassEntry.generatePass(minChars);
    var email = entry.getEmail();
    var title = entry.getTitle();
    var icon = entry.getIconId();
    var tag = entry.tag;
    var createdTime = entry.createdTime;
    var removedNumber = await DBProvider.DB.deletePassEntry(entry);
    HomePageState.Pairs.remove(entry);
    var newEntry = PassEntry.withIcon(
        username, password, title, email, icon, tag, createdTime);
    await DBProvider.DB.addPassEntry(newEntry);
    await HomePageState.changeDataset(() {
      HomePageState.Pairs.add(newEntry);
    });
    entry = HomePageState.Pairs.where((field) =>
        field.getUsername() == username &&
        password == field.getPassword() &&
        email == field.getEmail() &&
        title == field.getTitle() &&
        icon == field.getIconId() &&
        createdTime == field.createdTime).elementAt(0);
    this.password = password;
    dialog.state.loaded();
    setState(() {});
  }

  void cancelPasswordRegeneration() {
    Navigator.pop<RegeneratePasswordDialog>(context);
  }
}

class RegeneratePasswordDialog extends StatefulWidget {
  RegeneratePasswordDialog({VoidCallback onPositive, VoidCallback onNegative}) {
    this.onPositive = onPositive == null ? () {} : onPositive;
    this.onNegative = onNegative == null ? () {} : onNegative;
  }
  VoidCallback onPositive;
  VoidCallback onNegative;
  @override
  _RegeneratePasswordDialogState createState() =>
      _RegeneratePasswordDialogState(
        onPositive: onPositive,
        onNegative: onNegative,
      );
}

class _RegeneratePasswordDialogState extends State<RegeneratePasswordDialog> {
  _RegeneratePasswordDialogState(
      {VoidCallback onPositive, VoidCallback onNegative}) {
    this.onPositive = onPositive;
    this.onNegative = onNegative;
  }
  VoidCallback onPositive;
  VoidCallback onNegative;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocalizationTool.of(context).regenerateDialogWarningTitle,
        style:
            Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
      ),
      content: Text(
        LocalizationTool.of(context).regenerateDialogWarningContent,
      ),
      actions: <Widget>[
        // POSITIVE
        FlatButton(
            onPressed: onPositive,
            child: Text(
                LocalizationTool.of(context)
                    .regenerateDialogWarningPositiveAnswer,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.lightGreenAccent))),
        // NEGATIVE
        FlatButton(
            onPressed: onNegative,
            child: Text(
                LocalizationTool.of(context)
                    .regenerateDialogWarningNegativeAnswer,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.redAccent)))
      ],
    );
  }
}

enum PassEntryShareType {
  image,
  text,
}

String hidePassword(String password) {
  String result;
  StringBuffer buffer = StringBuffer();
  for (int i = 0; i < password.length; i++) {
    buffer.write("*");
  }
  result = buffer.toString();
  return result;
}

class ImageDialog extends StatelessWidget {
  var widget;
  ImageDialog(this.widget);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: widget,
    );
  }
}

class ChooseShareTypeDialog extends StatefulWidget {
  ScreenshotController screenshotController;
  PassEntry entry;
  PassEntryDetailsState details;
  ChooseShareTypeDialog(this.entry, this.screenshotController, details);
  @override
  State<StatefulWidget> createState() {
    return ChooseShareTypeDialogState(entry, screenshotController, details);
  }
}

class ChooseShareTypeDialogState extends State<ChooseShareTypeDialog> {
  PassEntryShareType _shareType = PassEntryShareType.image;
  ScreenshotController screenshotController;
  PassEntry entry;
  PassEntryDetailsState details;
  ChooseShareTypeDialogState(this.entry, this.screenshotController, details);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
          padding: EdgeInsets.all(15),
          child: Center(
              child: Text(LocalizationTool.of(context).shareTypeTitleChoice,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white)))),
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                  width: 100,
                  height: 48,
                  child: SvgPicture.asset(
                    "assets/images/ImageShareChoice.svg",
                    width: 100,
                    height: 49,
                  )),
              Text(LocalizationTool.of(context).shareTypeImage,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.white)),
              Radio(
                  groupValue: _shareType,
                  value: PassEntryShareType.image,
                  onChanged: (changed) {
                    setState(() {
                      _shareType = changed;
                    });
                  }),
            ],
          ), // IMAGE CHOICE
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.short_text,
                  size: 70, color: Color.fromARGB(153, 100, 150, 100)),
              Text(LocalizationTool.of(context).shareTypeText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.white)),
              Radio(
                  groupValue: _shareType,
                  value: PassEntryShareType.text,
                  onChanged: (changed) {
                    setState(() {
                      _shareType = changed;
                    });
                  }),
            ],
          )),
          // TEXT CHOICE
        ],
      )),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        FlatButton(
          child: Text(LocalizationTool.of(context).cancel,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.orangeAccent)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            LocalizationTool.of(context).share,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.lightGreenAccent),
          ),
          onPressed: () {
            switch (_shareType) {
              case PassEntryShareType.image:
                screenshotController
                    .capture(pixelRatio: 8)
                    .then((File image) async {
                  await Share.file(entry.getUsername(), "password.png",
                      await image.readAsBytes(), 'image/png');

                  details.setState(() {
                    details.isPasswordShown = false;
                  });
                });
                continue pop;
              case PassEntryShareType.text:
                var username = entry.getUsername();
                var password = entry.getPassword();
                var email = entry.getEmail();

                Share.text(
                    entry.getUsername(),
                    "Username: $username \nPassword: $password \nEmail: $email",
                    "text/plain");
                continue pop;
              pop:
              default:
                Navigator.pop(context);
            }
          },
        ),
      ]),
    ]));
  }
}
