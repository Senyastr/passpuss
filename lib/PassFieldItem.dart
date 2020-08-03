import 'package:PassPuss/auth/local_auth.dart';
import 'package:PassPuss/pages/homePage.dart';
import 'package:PassPuss/pages/settings/Privacy.dart';
import 'package:PassPuss/pages/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:PassPuss/Database.dart';
import "package:PassPuss/passentry.dart";
import 'package:flutter_svg/flutter_svg.dart';

import 'package:PassPuss/pages/PassEntryDetails.dart';
import 'localization.dart';

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

  @override
  void initState() {
    command = SimpleRemove(passEntry);
    passwordShowState = Icon(Icons.lock, key: passwordStateKey);
    iconLocked = Icon(Icons.lock, key: passwordStateKey);
    iconOpened = Icon(Icons.lock_open, key: passwordStateKey);
  }

  Icon iconLocked;
  Icon iconOpened;

  PassFieldState(PassEntry entry) {
    this.passEntry = entry;
  }

  var passwordShowState;
  var passwordStateKey = GlobalKey();
  var isPasswordShown = false;

  @override
  Widget build(BuildContext context) {
//    printMethod();
    String imageName = passEntry.getIconId();
    initState();

    return new Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => PassEntryDetails(passEntry)));
            },
            child: Card(
                child: Column(children: <Widget>[
              Align(
                  alignment: Alignment.topLeft,
                  child: Row(children: <Widget>[
                    Padding(
                        child: SvgPicture.asset(passEntry.getIconId()),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    Text(passEntry.getTitle(),
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete_forever,
                                  color: Colors.redAccent, size: 30),
                              onPressed: removeEntry,
                            )))
                  ])),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
                      child: Icon(Icons.person),
                    ),
                    Padding(
                        child: Text(passEntry.getUsername(),
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        padding:
                            EdgeInsets.only(left: 18, top: 10, bottom: 10)),
                    Padding(
                        padding: EdgeInsets.all(1),
                        child: IconButton(
                            icon: Icon(Icons.content_copy),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: passEntry.getUsername()));
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(LocalizationTool.of(context)
                                      .usernameCopied)));
                            })),
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
                            Clipboard.setData(
                                ClipboardData(text: passEntry.getPassword()));
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(LocalizationTool.of(context)
                                    .passwordCopied)));
                          })),
                ]),
              ),
            ]))));
  }

//  void printMethod() async {
//    String result = await MethodChannel("com.flutter.myapp/myapp").invokeMethod("MYMETHOD");
//    print(result);
// }
  RemoveCommand command;

  void removeEntry() async {
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
    if (isAuth) {
      HomePageState.changeDataset(() {
        HomePageState.Pairs.remove(passEntry);
        DBProvider.DB.deletePassEntry(passEntry);
      });
    }
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

abstract class RemoveCommand {
  void remove();
}

class SimpleRemove<T extends StatefulWidget> extends RemoveCommand {
  PassEntry entry;

  SimpleRemove(this.entry);

  @override
  void remove() {
    HomePageState.Pairs.remove(entry);
    DBProvider.DB.deletePassEntry(entry);
  }
}
