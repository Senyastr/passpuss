import 'package:PassPuss/logic/Database.dart';
import 'package:PassPuss/logic/autosync.dart';
import 'package:PassPuss/logic/localization.dart';
import 'package:PassPuss/view/pages/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../homePage.dart';

class DataSettingsTab extends StatefulWidget {
  DataSettingsTab({Key key}) : super(key: key);

  @override
  _DataSettingsTabState createState() => _DataSettingsTabState();
}

class _DataSettingsTabState extends State<DataSettingsTab> {
  String dataIconPath = "assets/images/storage-black-48dp.svg";
  SvgPicture dataIcon;
  String googleDriveIconPath = "assets/images/Logo_of_Google_Drive.svg";
  SvgPicture googleDriveIcon;

  @override
  void initState() {
    super.initState();
    dataIcon = SvgPicture.asset(dataIconPath,
        width: 40, height: 40, color: Colors.blueAccent);
    googleDriveIcon =
        SvgPicture.asset(googleDriveIconPath, width: 24, height: 24);
  }

  @override
  Widget build(BuildContext context) {
    var upperBody = _buildUpperPart(context);
    var googleDriveImportSetting = _buildGoogleDriveSetting(context);
    var layout = Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20), child: upperBody),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: _buildDivider()),
            SafeArea(
                child: Card(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      children: <Widget>[
                        // !!!! HERE ARE SETTINGS !!!!
                        // Password Expiration Notification Days
                        googleDriveImportSetting
                      ],
                    ))),
          ],
        )));
    return layout;
  }

  _buildDivider() {
    return Divider(
      color: Colors.blueAccent,
    );
  }

  Widget _buildUpperPart(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocalizationTool.of(context).data,
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.white),
        ),
        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Hero(tag: "data", child: dataIcon)),
      ],
    );
  }

  final String googleDriveAssetPath = "assets/images/Logo_of_Google_Drive.svg";
  Widget _buildGoogleDriveSetting(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(14),
            child: SvgPicture.asset(
              googleDriveAssetPath,
              width: 48,
              height: 48,
            )),
        Text(LocalizationTool.of(context).googleDrive,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white))
      ]),
      SafeArea(
          child: ListTile(
        leading: Text(
          LocalizationTool.of(context).autosync,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white),
        ),
        trailing: AutoSyncSwitch(),
      )),
      Row(mainAxisSize: MainAxisSize.min, children: [
        FlatButton(
          child: Text(LocalizationTool.of(context).export,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Theme.of(context).accentColor)),
          onPressed: exportPrompt,
        ),
        FlatButton(
          child: Text(LocalizationTool.of(context).import,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Theme.of(context).accentColor)),
          onPressed: importPrompt,
        ),
      ])
    ]));
  }

  void exportPrompt() async {
    await DBProvider.saveDrive();
  }

  void importPrompt() async {
    await DBProvider.exportDrive();
    HomePageState.changeDataset(() {});
  }
}

class AutoSyncSwitch extends StatefulWidget {
  static final String AutoSyncSwitchSetting = "AutoSyncDrive";
  @override
  State<StatefulWidget> createState() {
    return AutoSyncSwitchState();
  }
}

class AutoSyncSwitchState extends State<AutoSyncSwitch> {
  bool _isAutoSync = false;
  @override
  void initState() {
    super.initState();

    lateInitSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: onChangedSync,
      value: _isAutoSync,
    );
  }

  void onChangedSync(bool value) async {
    _isAutoSync = !_isAutoSync;
    await SettingsManager.changePref(
        AutoSyncSwitch.AutoSyncSwitchSetting, _isAutoSync);
    if (_isAutoSync) {
      await DBProvider.saveDrive();
    }

    // TODO: Implement AutoSync
    setState(() {});
  }

  void lateInitSetting() async {
    var result = await SettingsManager.getPref(AutoSyncSwitch.AutoSyncSwitchSetting);
    _isAutoSync = result == null ? false : result;
    setState(() {});
  }
}
