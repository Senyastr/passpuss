import 'package:PassPuss/logic/localization.dart';
import 'package:PassPuss/view/pages/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForYouSettingsTab extends StatefulWidget {
  ForYouSettingsTab({Key key}) : super(key: key);

  @override
  ForYouSettingsTabState createState() => ForYouSettingsTabState();
}

class ForYouSettingsTabState extends State<ForYouSettingsTab>
    implements SettingsTab {
  static final String qwertyKey = "qwertyForYou";
  static final String charsAllowedKey = "charsForYou";
  var thumpUpIcon = Icon(
    Icons.thumb_up,
    color: Colors.indigo,
    size: 40,
  );

  bool onlyLetters = true;

  static final String onlyLettersSetting = "onlyLettersSetting";
  @override
  void initState() {
    super.initState();
    initSettings();
  }

  @override
  void initSettings() async {
    sharedPrefs = await SharedPreferences.getInstance();
    dynamic temp; // QWERTY SETTING
    await initQwertySetting();
    await initCharsSetting();
    await initOnlyLettersSetting();
    setState(() {});
  }

  Future<void> initQwertySetting() async {
    var temp = await SettingsManager.getPref<bool>(qwertyKey);
    qwertySettingValue = temp == null ? true : temp; // DEFAULT : TRUE
  }

  Future<void> initCharsSetting() async {
    var temp = await SettingsManager.getPref<int>(charsAllowedKey);
    charsAllowed = temp == null ? 8 : temp;
  }

  Future<void> initOnlyLettersSetting() async {
    var temp = await SettingsManager.getPref<bool>(onlyLettersSetting);
    onlyLetters = temp == null ? true : false;
  }

  var qwertySettingValue = true;

  double charsAllowed = 8;

  SharedPreferences sharedPrefs;

  @override
  Widget build(BuildContext context) {
    var upperPart = _buildUpperPart(context);
    var qwertySetting = _buildQwertySetting(context);
    var onlyLettersSetting = _buildOnlyLettersSetting(context);
    var charsSetting = _buildCharsSetting(context);
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            SafeArea(
                child: Padding(padding: EdgeInsets.all(10), child: upperPart)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Divider(),
            ),
            Column(
              children: <Widget>[
                qwertySetting,
                Divider(),
                onlyLettersSetting,
                Divider(),
                charsSetting,
                Divider(),
              ],
            )
          ],
        ));
  }

  Widget _buildUpperPart(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        LocalizationTool.of(context).forYou,
        style:
            Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20),
        child: Hero(tag: "forYou", child: thumpUpIcon),
      ),
    ]);
  }

  Widget _buildQwertySetting(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.language,
          color: Colors.white,
        ),
        title: Text(LocalizationTool.of(context).qwertySetting,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.white,
                )),
        trailing: Switch(
          onChanged: qwertySetting,
          value: qwertySettingValue,
        ));
  }

  Widget _buildOnlyLettersSetting(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.title,
        color: Colors.white,
      ),
      title: Text(
        LocalizationTool.of(context).onlyLettersSetting,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
      ),
      trailing: Switch(
        onChanged: onlyLettersChanged,
        value: onlyLetters,
      ),
    );
  }

  Widget _buildCharsSetting(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.text_rotation_none,
        color: Colors.white,
      ),
      title: Text(LocalizationTool.of(context).charsSetting,
          softWrap: true,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.white,
              )),
      trailing: Container(
          height: 40,
          width: 125,
          child: Slider(
            value: charsAllowed,
            min: 1,
            max: 8,
            onChanged: charsAllowedChanged,
            divisions: 7,
            label: "$charsAllowed",
          )),
    );
  }

  void qwertySetting(bool value) async {
    setState(() {
      qwertySettingValue = value;
    });
    sharedPrefs.setBool(qwertyKey, value);
  }

  void charsAllowedChanged(double value) async {
    charsAllowed = value;
    sharedPrefs.setDouble(charsAllowedKey, value);
    setState(() {});
  }

  void onlyLettersChanged(bool value) async {
    await SettingsManager.changePref(onlyLettersSetting, value);
    onlyLetters = value;
    setState(() {});
  }
}
