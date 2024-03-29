import 'package:PassPuss/logic/autosync.dart';
import 'package:PassPuss/view/message.dart';
import 'package:PassPuss/view/pages/settings/ForYou.dart';
import 'package:PassPuss/logic/passentry.dart';
import 'package:PassPuss/view/pages/settings/settings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:PassPuss/logic/Database.dart';
import '../NewPassEntry.dart';
import 'package:PassPuss/logic/localization.dart';
import 'homePage.dart';
import 'package:PassPuss/view/page.dart' as Page;

class EditEntryPage extends StatefulWidget implements Page.Page {
  EditEntryPage(this.entry);

  PassEntry entry;

  @override
  State<StatefulWidget> createState() {
    return EditEntryState(entry);
  }
}

abstract class IconChoiced {
  PassEntryIcon selected;
  void update();
}

class EditEntryState extends State<EditEntryPage> implements IconChoiced {
  final _formKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey();
  final _titleKey = GlobalKey();
  final _emailKey = GlobalKey();
  TextFormField _passwordForm;
  TextFormField _usernameForm;
  TextFormField _titleForm;
  TextFormField _emailForm;
  ListView icons;

  String username = "";
  String password = "";
  String preview_password = "";
  String title = "";
  String email = "";
  Tags tag;

  String hiddenPassword = "*******";

  bool generate_mode = false;

  double _sliderHeight = 0.0;

  double _genChars = 8;

  PassEntry entry;
  double charsMin = 8;

  var emailWarningHeight = 0.0;

  bool emailAcceptable = true;

  @override
  void initState() {
    super.initState();
    selected = null;
    lockIcon = Icon(iconLocked);
    password_preview = hiddenPassword;
    IconChoiceState.initOnChange(new IconChangedHandler(this));
    IconChoiceState.icons = iconsChoice;
    IconChoiceState.selected = null;

    username = entry.getUsername();
    password = entry.getPassword();
    title = entry.getTitle();
    var iconId = entry.getIconId();
    if (iconId != IconChoiceState.emptyIconPath) {
      this.selected = iconsChoice.where((e) {
        return e.path == entry.getIconId();
      }).toList()[0];
    }

    username_txt.text = entry.getUsername();
    password_txt.text = entry.getPassword();
    title_txt.text = entry.getTitle();
    tag = entry.tag;
    assignSettings();
  }

  void update() {
    setState(
        () {}); // here we can invoke it from the outside code and update the widget
  }

  bool previewPassword = false;
  Icon lockIcon;
  var iconLocked = Icons.lock;
  var iconOpened = Icons.lock_open;
  var isPasswordShown = false;
  PassEntryIcon selected;

  var passwordStateKey = GlobalKey();

  // CONTROLLERS
  final password_txt = TextEditingController();
  final username_txt = TextEditingController();
  final title_txt = TextEditingController();
  final iconsChoice = NewPassEntry.iconsChoice;
  String password_preview;

  ListView iconChoices;

  @override
  Widget build(BuildContext context) {
    iconChoices = ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: iconsChoice.length,
        itemBuilder: (BuildContext context, int index) {
          var el = iconsChoice[index];
          var iconWidget;
          if (entry.getIconId() == el.path) {
            iconWidget = IconChoice(el, true);
          } else {
            iconWidget = IconChoice(el, false);
          }
          return iconWidget;
        });

    _usernameForm = _buildUsernameForm(context);
    _passwordForm = _buildPasswordForm(context);
    _emailForm = _buildEmailForm(context);
    _titleForm = _buildTitleForm(context);
    password_txt.addListener(onPasswordChanged);
    username_txt.addListener(onUsernameChanged);
    title_txt.addListener(onTitleChanged);
    var preview = _buildPreview(context);
    var formsCard = _buildFormsCard(context);
    return Form(
        key: _formKey,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(LocalizationTool.of(context).editPasswordPage),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    await updateEntry(context);
                  },
                )
              ],
            ),
            body: Column(children: <Widget>[
              Expanded(
                  child: Wrap(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(16), child: preview)
                ],
              )),
              Expanded(
                child: SingleChildScrollView(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Wrap(children: <Widget>[formsCard]))),
              )
            ])));
  }

  Widget _buildUsernameForm(BuildContext context) {
    return TextFormField(
      controller: username_txt,
      autovalidate: true,
      validator: (value) =>
          value.isEmpty ? LocalizationTool.of(context).usernameBlank : null,
      key: _usernameKey,
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: LocalizationTool.of(context).newPasswordUsernameHint,
          labelText: LocalizationTool.of(context).newPasswordUsernameLabel),
    );
  }

  Widget _buildPasswordForm(BuildContext context) {
    return TextFormField(
      enabled: !generate_mode,
      autovalidate: true,
      validator: (value) => password_txt.text.length < 8
          ? LocalizationTool.of(context).newPasswordMore8Chars
          : null,
      controller: password_txt,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(Icons.lock),
          hintText: LocalizationTool.of(context).newPasswordFormHint,
          labelText: LocalizationTool.of(context).password),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return TextFormField(
        autovalidate: true,
        onChanged: (String changed) {
          email = changed;

          if (!email.contains("@")) {
            emailAcceptable = false;
            emailWarningHeight = 30;
          } else {
            emailAcceptable = true;
            emailWarningHeight = 0;
          }
          update();
        },
        key: _emailKey,
        decoration: InputDecoration(
            hintText: LocalizationTool.of(context).newPasswordEmailHint,
            labelText: LocalizationTool.of(context).newPassswordEmailLabel,
            icon: Icon(Icons.email)));
  }

  Widget _buildTitleForm(BuildContext context) {
    return TextFormField(
        controller: title_txt,
        autovalidate: true,
        validator: (val) => (val.isEmpty)
            ? LocalizationTool.of(context).newPasswordTitleNotEmpty
            : null,
        key: _titleKey,
        decoration: InputDecoration(
            hintText: LocalizationTool.of(context).newPasswordTitleHint,
            labelText: LocalizationTool.of(context).title,
            icon: Icon(Icons.title)));
  }

  Widget _buildPreview(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      child: (this.selected != null)
                          ? SvgPicture.asset(this.selected.path)
                          : SvgPicture.asset(IconChoiceState.emptyIconPath),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                  Expanded(
                      child: AutoSizeText(
                    "$title",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    maxLines: 1,
                    minFontSize: 8,
                  )),
                  Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: TagHelper.widgetByTag(tag)),
                ],
              )), // ICON PREVIEW
          Align(
              alignment: Alignment.bottomLeft,
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
                  child: Icon(Icons.person),
                ),
                Expanded(
                    child: Padding(
                        child: AutoSizeText(
                          username_txt.text,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          maxLines: 1,
                          minFontSize: 8,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 5))),
                Padding(
                    padding: EdgeInsets.all(1),
                    child: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: username));
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(LocalizationTool.of(context)
                                  .usernameCopied)));
                        })),
              ])), // USERNAME PREVIEW
          Align(
              alignment: Alignment.bottomLeft,
              child: Row(children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 10, top: 10),
                    child: IconButton(
                      icon: lockIcon,
                      onPressed: () {
                        setState(() {
                          if (lockIcon.icon == iconLocked) {
                            lockIcon = Icon(iconOpened);
                            password_preview = password_txt.text;
                            previewPassword = true;
                          } else {
                            lockIcon = Icon(iconLocked);
                            password_preview = hidePassword(password_txt.text);
                            previewPassword = false;
                          }
                        });
                      },
                    )),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: AutoSizeText(
                          password_preview,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          minFontSize: 8,
                          maxLines: 1,
                        ))),
                Padding(
                    padding: EdgeInsets.only(),
                    child: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: password_txt.text));
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(LocalizationTool.of(context)
                                  .passwordCopied)));
                        }))
              ])), // password_password_txt.text PREVIEW
        ]));
  }

  Widget _buildFormsCard(BuildContext context) {
    return Card(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(// Username
            children: <Widget>[
          Expanded(
              child: Padding(padding: EdgeInsets.all(14), child: _usernameForm))
        ]), // Username Field,
        Row(children: <Widget>[
          Expanded(
              child:
                  Padding(padding: EdgeInsets.all(14), child: _passwordForm)),
          IconButton(
              icon: Icon(Icons.lightbulb_outline,
                  color: generate_mode ? Colors.yellow : Colors.black),
              onPressed: () {
                setState(() {
                  generate_mode = !generate_mode;
                  _sliderHeight = generate_mode ? 100.0 : 0.0;
                });
              })
        ]),
        AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _sliderHeight,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 17, top: 4),
                    child:
                        Text(LocalizationTool.of(context).passwordGenSelect)),
                Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.red[700],
                          inactiveTrackColor: Colors.red[100],
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          thumbColor: Colors.redAccent,
                          overlayColor: Colors.red.withAlpha(32),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.red[700],
                          inactiveTickMarkColor: Colors.red[100],
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.redAccent,
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider(
                            value: _genChars,
                            min: charsMin,
                            max: 16,
                            label: '$_genChars',
                            divisions: 8,
                            onChanged: (val) {
                              setState(() {
                                _genChars = val;
                              });
                            }))),
              ],
            )),
        // password_password_txt.text
        Row(children: <Widget>[
          Expanded(
              child: Padding(padding: EdgeInsets.all(14), child: _titleForm)),
        ]),
        Row(children: <Widget>[
          Expanded(
              child: Padding(padding: EdgeInsets.all(14), child: _emailForm)),
        ]), //EMAIL,
        AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: emailWarningHeight,
            child: !emailAcceptable
                ? ListTile(
                    contentPadding: EdgeInsets.only(left: 15, right: 15),
                    trailing: Icon(
                      Icons.warning,
                      color: Colors.amber,
                    ),
                    title: Text(
                      LocalizationTool.of(context).emailWarning,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.amber),
                    ),
                  )
                : Container()),

        Padding(
            padding: EdgeInsets.all(15),
            child: ListTile(
                title:
                    Text("Tag", style: Theme.of(context).textTheme.bodyText2),
                trailing: DropdownButton(
                  value: tag,
                  onChanged: (value) {
                    tag = value;
                    setState(() {});
                  },
                  items: Tags.values.map<DropdownMenuItem<Tags>>((Tags value) {
                    return DropdownMenuItem<Tags>(
                        value: value, child: TagHelper.widgetByTag(value));
                  }).toList(),
                ))),
        // TITLE
        Padding(
            padding: EdgeInsets.only(bottom: 30, left: 14, right: 14),
            child: Container(child: iconChoices, height: 50)) // ICONS
      ],
    )));
  }

  Future<void> updateEntry(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      // AUTO SYNC PREF
      password = generate_mode
          ? PassEntry.generatePass(_genChars.toInt())
          : password_txt.text;
      var pref = await SettingsManager.getPref(AutoSyncService.AutoSyncSetting)
          as bool;
      bool autoSyncService = pref == null ? false : pref;
      var dialog = ResultDialog("");
      showDialog(context: context, builder: (context) => dialog);
      var newEntry = PassEntry.withIcon(username, password, title, email,
          selected.path, tag, entry.createdTime);
      await DBProvider.getDB().deletePassEntry(entry);
      HomePageState.Pairs.remove(entry);
      await DBProvider.getDB()
          .addPassEntry(newEntry, isSyncDrive: autoSyncService);
      HomePageState.changeDataset(() {
        HomePageState.Pairs.add(newEntry);
      });
      dialog.state.loaded();
    }
  }

  void onPasswordChanged() {
    setState(() {
      password = password_txt.text;
      if (previewPassword) {
        password_preview = password_txt.text;
      } else {
        password_preview = hidePassword(password_txt.text);
      }
    });
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

  void onUsernameChanged() {
    setState(() {
      username = username_txt.text;
    });
  }

  void onTitleChanged() {
    setState(() {
      title = title_txt.text;
    });
  }

  EditEntryState(this.entry);

  void assignSettings() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var temp = sharedPrefs.getDouble(ForYouSettingsTabState.charsAllowedKey);
    charsMin = temp == null ? 8 : temp;
    setState(() {});
  }
}
