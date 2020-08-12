import 'dart:math';

import 'package:PassPuss/message.dart';
import 'package:PassPuss/pages/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../localization.dart';
import 'package:get_version/get_version.dart';
import 'package:PassPuss/auth/local_auth.dart';

class PrivacySettingsTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PrivacySettingsTabState();
  }
}

class PrivacySettingsTabState extends State<PrivacySettingsTab>
    implements SettingsTab {
  GlobalKey encryptedSwitch = GlobalKey();

  bool isVerifyingCompatible = true;

  var privacyIcon = Icon(
    Icons.lock,
    color: Colors.blueAccent,
    size: 40,
  );

  var authRemoveValue = false;

  static final String authVerifyRemoveEntrySetting =
      "authVerifyRemoveEntrySetting";

  @override
  void initState() {
    super.initState();
    initSettings();
  }

  String OsVersion;
  bool isVerifying = false;
  static final String isVerifyingKey = "auth";
  @override
  Widget build(BuildContext context) {
    var temp = Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      LocalizationTool.of(context).privacy,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.white),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Hero(tag: "privacy", child: privacyIcon)),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Divider(),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.enhanced_encryption, color: Colors.white),
                  title: Text(
                    LocalizationTool.of(context).privacySettingsEncryption,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white),
                  ),
                  // ignore: missing_required_param
                  trailing: Switch(
                    value: true,
                    key: encryptedSwitch,
                    inactiveTrackColor: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(),
                isVerifyingCompatible
                    ? ListTile(
                        leading: Icon(Icons.fingerprint, color: Colors.white),
                        title: Text(
                            LocalizationTool.of(context)
                                .fingerprintAuthentication,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.white)),
                        trailing: Switch(
                          onChanged: fingerprintAuthChanged,
                          value: isVerifying,
                        ))
                    : Container(),
                Divider(),
                isVerifyingCompatible
                    ? ListTile(
                        leading: Icon(Icons.delete, color: Colors.white),
                        title: Text(
                            LocalizationTool.of(context)
                                .removeEntryFingerprintSetting,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.white)),
                        trailing: Switch(
                            onChanged: isVerifying
                                ? (changed) => authRemove(changed)
                                : null,
                            value: authRemoveValue),
                      )
                    : Container(),
              ],
            )
          ],
        ));
    return temp;
  }

  @override
  void initSettings() async {
    // IS AUTH
    dynamic temp = await SettingsManager.getPref(
        PrivacySettingsTabState.isVerifyingKey.toString()) as bool;
    isVerifying = (temp == null ? false : temp);
    // AUTH COMPATIBILITY // WORKS ONLY WHEN WE HAVE ANDROID PIE OR MORE
    try {
      OsVersion = await GetVersion.platformVersion;
    } on PlatformException {
      OsVersion = "Failed";
    }
    var split = OsVersion.split(" ");
    if (split[0] == "Android") {
      var androidV = (split[1]);

      if (await LocalAuthentication().canCheckBiometrics) {
        isVerifyingCompatible =
            isVerifyingCompatible = double.parse(androidV.split(".")[0]) > 9;
      }
    }

    // REMOVE PASS ENTRY AUTHENTICATION
    temp = (await SettingsManager.getPref(
        PrivacySettingsTabState.authVerifyRemoveEntrySetting)) as bool;
    authRemoveValue = temp == null ? false : temp;

    // finally, update UI
    setState(() {});
  }

  void fingerprintAuthChanged(bool value) async {
    var localAuth = LocalAuthentication();
    bool hasAuthenticated = await localAuth.authenticateWithBiometrics(
        localizedReason:
            LocalizationTool.of(context).fingerprintStartDialogReason);
    if (hasAuthenticated) {
      await SettingsManager.changePref(
          PrivacySettingsTabState.isVerifyingKey.toString(), value);
      setState(() {
        isVerifying = value;
      });
      if (isVerifying) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FingerprintBackup()));
      }
    }
  }

  authRemove(bool changed) async {
    var localAuth = LocalAuthentication();
    bool hasAuthenticated = await localAuth.authenticateWithBiometrics(
        localizedReason:
            LocalizationTool.of(context).fingerprintAuthRemoveSetup);
    if (hasAuthenticated) {
      SettingsManager.changePref(authVerifyRemoveEntrySetting, changed);
      authRemoveValue = changed;
      setState(() {});
    }
  }
}

class FingerprintBackup extends StatefulWidget {
  FingerprintBackup({Key key}) : super(key: key);

  @override
  FingerprintBackupState createState() => FingerprintBackupState();
}

class FingerprintBackupState extends State<FingerprintBackup> {
  FingerprintBackupKey backupKey;
  static final backupKeySetting = "backupCode";
  @override
  void initState() {
    super.initState();
    backupKey = FingerprintBackupKey();
    backupKey.init();
    saveBackupCode();
  }

  void saveBackupCode() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(backupKeySetting, backupKey.getKey());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                LocalizationTool.of(context).backupFingerprintKeyTitle,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.white),
              )),
          Container(
              decoration: BoxDecoration(color: Colors.lightGreen),
              child: Text(
                backupKey.getKey(),
                style: Theme.of(context).textTheme.headline4,
              )),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
                LocalizationTool.of(context).fingerprintBackupWindowText,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.white)),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  child: Text(LocalizationTool.of(context).proceed),
                  onPressed: () {
                    showDialog(
                        builder: (context) {
                          var dialog = ResultDialog("message",
                              type: ResultType.positive);
                          return dialog;
                        },
                        context: context);
                  },
                  color: Theme.of(context).accentColor,
                ),
              )),
        ],
      )),
    );
  }
}

class FingerprintBackupKey {
  String _key;
  bool _isInit;
  void init() {
    _key = randomKey();
    _isInit = true;
  }

  String getKey() {
    if (_isInit) {
      return _key;
    }
  }

  var randomSet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0'
  ];
  String randomKey() {
    // result is random: BXXXXXXX
    var chars = 7;
    var result = "B";
    Random random = Random();
    for (var i = 0; i < chars; i++) {
      result += randomSet[random.nextInt(randomSet.length - 1)].toString();
    }
    return result;
  }
}
