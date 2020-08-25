import 'package:PassPuss/view/NewPassEntry.dart';
import 'package:PassPuss/logic/auth/local_auth.dart';
import 'package:PassPuss/view/message.dart';
import 'package:PassPuss/view/pages/homePage.dart';
import 'package:PassPuss/view/pages/settings/Privacy.dart';
import 'package:PassPuss/view/pages/settings/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:PassPuss/logic/Database.dart';
import 'package:PassPuss/logic/passentry.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:PassPuss/view/pages/PassEntryDetails.dart';
import '../logic/ads/adManager.dart';
import '../logic/localization.dart';

class PassField extends StatefulWidget {
  PassEntry passEntry;

  @override
  State<StatefulWidget> createState() {
    return PassFieldState(passEntry);
  }

  PassField(PassEntry passentry, GlobalKey<State<StatefulWidget>> globalKey)
      : super(key: globalKey) {
    this.passEntry = passentry;
  }
}

class PassFieldState extends State<PassField> {
  PassEntry passEntry;

  var id;

  @override
  void initState() {
    passwordShowState = Icon(Icons.lock, key: passwordStateKey);
    iconLocked = Icon(Icons.lock, key: passwordStateKey);
    iconOpened = Icon(Icons.lock_open, key: passwordStateKey);
    id = passEntry.id;
  }

  Icon iconLocked;
  Icon iconOpened;
  var isPasswordShown = false;

  PassFieldState(PassEntry entry) {
    this.passEntry = entry;
  }

  var passwordShowState;
  var passwordStateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    initState();
    var icon = _buildEntryIcon(context);
    var title = _buildTitle(context);
    var usernameField = _buildUsernameField(context);
    var passwordField = _buildPasswordField(context);
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => PassEntryDetails(passEntry)));
              AdManager.tryShowInterstitialAd();
            },
            child: Card(
                child: Column(children: <Widget>[
              Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(children: [
                          icon,
                          title,
                        ]),
                        Row(children: [
                          passEntry.tag != null
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: TagHelper.widgetByTag(passEntry.tag))
                              : Container(),
                          Padding(
                              padding: EdgeInsets.only(left: 1),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: _buildRemoveButton(context))),
                        ]),
                      ])),
              Align(alignment: Alignment.bottomLeft, child: usernameField),
              Align(alignment: Alignment.bottomLeft, child: passwordField),
            ]))));
  }

  Widget _buildEntryIcon(BuildContext context) {
    var icon = SvgPicture.asset(passEntry.getIconId());
    return Padding(
        child: Hero(tag: "entryIcon$id", child: icon),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10));
  }

  Widget _buildTitle(BuildContext context) {
    return Text(passEntry.getTitle(),
        style: TextStyle(fontSize: 20, color: Colors.white));
  }

  Widget _buildUsernameField(BuildContext context) {
    return Row(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
        child: Icon(Icons.person),
      ),
      Padding(
          child: Text(passEntry.getUsername(),
              style: TextStyle(fontSize: 20, color: Colors.white)),
          padding: EdgeInsets.only(left: 18, top: 10, bottom: 10)),
      Padding(
          padding: EdgeInsets.all(1),
          child: IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: passEntry.getUsername()));
                Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text(LocalizationTool.of(context).usernameCopied)));
              })),
    ]);
  }

  Widget _buildPasswordField(BuildContext context) {
    return Row(children: <Widget>[
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
          padding: EdgeInsets.only(left: 6, top: 10, bottom: 10),
          child: Text(
              (isPasswordShown)
                  ? passEntry.getPassword()
                  : hidePassword(passEntry.getPassword()),
              style: TextStyle(fontSize: 20, color: Colors.white))),
      Padding(
          padding: EdgeInsets.all(1),
          child: IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: passEntry.getPassword()));
                Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text(LocalizationTool.of(context).passwordCopied)));
              })),
    ]);
  }

  Widget _buildRemoveButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_forever, color: Colors.redAccent, size: 30),
      onPressed: tryRemoveEntry,
    );
  }

  void tryRemoveEntry() {
    var dialog = DeleteEntryWarningDialog(passEntry, removeEntry,
        () => Navigator.popUntil(context, (route) => route.isFirst));
    showDialog(context: context, builder: (context) => dialog);
  }

  Future<void> removeEntry() async {
    

    var isAuth = await authenticate();
    if (isAuth) {
      ResultDialog dialog = ResultDialog("message", type: ResultType.positive);
    showDialog(context: context, builder: (context) => dialog);
      HomePageState.changeDataset(() async {
        // GETTING INDEX OF THIS PAIR(USED FOR POINTING WHAT ELEMENT'S GOTTA BE ANIMATED)
        var index = HomePageState.Pairs.indexOf(passEntry);
        // REMOVING FROM HOMEPAGE
        HomePageState.Pairs.remove(passEntry);
        // REMOVING FORM DB
        DBProvider.DB.deletePassEntry(passEntry);
        // ANIMATING
        var animatedListState = HomePageState.animatedListKey.currentState;
        if (animatedListState != null) {
          animatedListState.removeItem(
              index,
              (context, animation) =>
                  HomePageState.buildItem(passEntry, animation));
        }
      });
    }
  }

  Future<bool> authenticate() async {
    bool isAuth;
    var auth = await SettingsManager.getPref(
        PrivacySettingsTabState.authVerifyRemoveEntrySetting) as bool;
    if (auth != null && auth) {
      var localAuthentication = LocalAuthentication();
      var hasAuth = await localAuthentication.authenticateWithBiometrics(
          localizedReason:
              LocalizationTool.of(context).removeEntryFingerprintPrompt);
      isAuth = hasAuth;
    } else {
      isAuth = true;
    }
    return isAuth;
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
}

class DeleteEntryWarningDialog extends StatefulWidget {
  PassEntry entry;
  VoidCallback positive;
  VoidCallback negative;
  DeleteEntryWarningDialog(this.entry, this.positive, this.negative);
  @override
  _DeleteEntryWarningDialogState createState() =>
      _DeleteEntryWarningDialogState(entry, positive, negative);
}

typedef AsyncVoidCallback = Future<void> Function();

class _DeleteEntryWarningDialogState extends State<DeleteEntryWarningDialog> {
  PassEntry entry;
  AsyncVoidCallback positiveCallback;
  VoidCallback negativeCallback;
  _DeleteEntryWarningDialogState(
      this.entry, this.positiveCallback, this.negativeCallback);
  @override
  Widget build(BuildContext context) {
    var actions = _buildActions(context);
    return AlertDialog(
      actions: actions,
      title: Text(LocalizationTool.of(context).deleteEntryWarningDialogTitle,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white)),
      content: Text(
        LocalizationTool.of(context).deleteEntryWarningDialogContent,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    var actions = [
      FlatButton(
          onPressed: () {
            positive(context);
          },
          child: Text(
              LocalizationTool.of(context).deleteEntryWarningPositiveButton,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.lightGreenAccent))),
      FlatButton(
          onPressed: negative,
          child: Text(
              LocalizationTool.of(context).deleteEntryWarningNegativeButton,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.redAccent)))
    ].toList();
    return actions;
  }

  Future<void> positive(BuildContext context) async {
    if (positiveCallback != null) {
      await positiveCallback();
    }
  }

  void negative() {
    if (negativeCallback != null) {
      negativeCallback();
    }
  }
}
