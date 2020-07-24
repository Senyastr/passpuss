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
    // TODO: implement createState
    return PrivacySettingsTabState();
  }
}

class PrivacySettingsTabState extends State<PrivacySettingsTab>
    implements SettingsTab {
  GlobalKey encryptedSwitch = GlobalKey();

  bool isVerifyingCompatible = true;

  var privacyIcon =  Icon(
                        Icons.lock,
                        color: Colors.blueAccent,
                        size: 40,
                      );

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
    // TODO: implement build
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
                      child:privacyIcon
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Divider(),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
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
                        leading: Text(
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
              ],
            )
          ],
        ));
    return temp;
  }

  @override
  void initSettings() async {
    // IS AUTH
    var temp = await SettingsManager.getPref(
        PrivacySettingsTabState.isVerifyingKey.toString()) as bool;
    isVerifying = (temp == null ? false : temp);
    // AUTH COMPATIBILITY // WORKS ONLY WHEN WE HAVE ANDROID PIE OR MORE
    // TODO: Implement Authentication for android 8.1 and less
    try {
      OsVersion = await GetVersion.platformVersion;
    } on PlatformException {
      OsVersion = "Failed";
    }
    var split = OsVersion.split(" ");
    if (split[0] == "Android") {
      var androidV = (split[1]);
      isVerifyingCompatible = double.parse(androidV.split(".")[0]) > 9;
    }

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
    }
  }
}
