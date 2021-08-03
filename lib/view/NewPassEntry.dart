import 'package:PassPuss/logic/autosync.dart';
import 'package:PassPuss/logic/localization.dart';
import 'package:PassPuss/view/message.dart';
import 'package:PassPuss/view/pages/editEntryPage.dart';
import 'package:PassPuss/view/pages/settings/ForYou.dart';
import 'package:PassPuss/view/pages/settings/Notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:PassPuss/logic/passentry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic/Database.dart';
import 'package:PassPuss/view/pages/homePage.dart';
import 'package:PassPuss/view/pages/settings/settings.dart';
import '../logic/ads/adManager.dart';
import '../logic/notifications.dart';

class NewPassEntryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPassEntry();
  }
}

class NewPassEntry extends State<NewPassEntryPage> implements IconChoiced {
  final _formKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey();
  final _titleKey = GlobalKey();
  final _emailKey = GlobalKey();
  TextFormField _passwordForm;
  TextFormField _usernameForm;
  TextFormField _titleForm;
  ListView icons;

  String username = "";
  String password = "";
  String previewPass = "";
  String title = "";
  String email = "";

  bool generate_mode = false;
  bool emailAcceptable = true;
  double _sliderHeight = 0.0;

  double _genChars = 8;

  TextFormField _emailForm;

  double emailWarningHeight = 0;

  double charsMin = 8;

  Tags tag = Tags.white;

  @override
  void initState() {
    selected = null;
    lockIcon = Icon(iconLocked);
    passwordPreview = "";
    IconChoiceState.initOnChange(new IconChangedHandler(this));
    IconChoiceState.icons = iconsChoice;
    IconChoiceState.selected = null;
    assignSettings();
    AdManager.initInterstitialAd();
    AdManager.loadInterstitialAd();
  }

  void update() {
    setState(
        () {}); // here we can invoke it from the outside code and update the widget
  }

  bool previewPassword = false;
  Icon lockIcon;
  var iconLocked = Icons.lock;
  var iconOpened = Icons.lock_open;
  PassEntryIcon selected;
  var passwordStateKey = GlobalKey();
  var isPasswordShown = false;
  var password_txt = TextEditingController();
  static var iconsChoice = [
    PassEntryIcon("assets/images/Google48x48.svg"),
    PassEntryIcon("assets/images/Instagram_logo_2016.svg"),
    PassEntryIcon("assets/images/Facebook_logo_24x24.svg"),
    PassEntryIcon("assets/images/reddit copy.svg"),
    PassEntryIcon("assets/images/Apple48x48.svg"),
    PassEntryIcon("assets/images/Spotify48x48.svg"),
    PassEntryIcon("assets/images/Steam48x48.svg"),
    PassEntryIcon("assets/images/twitter-seeklogo.svg"),
    PassEntryIcon("assets/images/Microsoft48x48.svg"),
    PassEntryIcon("assets/images/Yandex_Browser_logo.svg"),
    PassEntryIcon("assets/images/Creative_Cloud.svg"),
    PassEntryIcon("assets/images/Netflix_icon.svg")
  ];
  String passwordPreview;

  @override
  Widget build(BuildContext context) {
    _usernameForm = _buildUsernameForm(context);
    _passwordForm = _buildPasswordForm(context);
    _emailForm = _buildEmailForm(context);
    _titleForm = _buildTitleForm(context);
    password_txt.addListener(onPasswordChange);
    var preview = _buildPreview(context);
    var formsCard = _buildFormsCard(context);
    return Form(
        key: _formKey,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(LocalizationTool.of(context).createNewPassword),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    createEntry(context);
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
      autovalidateMode: AutovalidateMode.always,
      validator: (value) =>
          username.isEmpty ? LocalizationTool.of(context).usernameBlank : null,
      onChanged: (String changed) {
        setState(() {
          username = changed;
        });
      },
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
      autovalidateMode: AutovalidateMode.always,
      validator: (value) =>
      password.length < 8
          ? LocalizationTool
          .of(context)
          .newPasswordMore8Chars
          : null,
      controller: password_txt,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(Icons.lock),
          hintText: LocalizationTool
              .of(context)
              .newPasswordFormHint,
          labelText: LocalizationTool
              .of(context)
              .password),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return TextFormField(
        autovalidateMode: AutovalidateMode.always,
        onChanged: (String changed) {
          email = changed;

          if (!email.contains("@")) {
            emailAcceptable = false;
            emailWarningHeight = 30;
          } else {
            emailAcceptable = true;
            emailWarningHeight = 0;
          }
          setState(() {});
        },
        key: _emailKey,
        decoration: InputDecoration(
            hintText: LocalizationTool.of(context).newPasswordEmailHint,
            labelText: LocalizationTool.of(context).newPassswordEmailLabel,
            icon: Icon(Icons.email)));
  }

  Widget _buildTitleForm(BuildContext context) {
    return TextFormField(
        autovalidateMode: AutovalidateMode.always,
        validator: (val) =>
        (val.isEmpty)
            ? LocalizationTool
            .of(context)
            .newPasswordTitleNotEmpty
            : null,
        onChanged: (String changed) {
          setState(() {
            title = changed;
          });
        },
        key: _titleKey,
        decoration: InputDecoration(
            hintText: LocalizationTool
                .of(context)
                .newPasswordTitleHint,
            labelText: LocalizationTool
                .of(context)
                .title,
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
                        child: (IconChoiceState.selected != null)
                            ? SvgPicture.asset(
                                IconChoiceState.selected.iconInfo?.path)
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
                  ])), // ICON PREVIEW
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
                          username,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          minFontSize: 8,
                          maxLines: 1,
                        ),
                        padding:
                            EdgeInsets.only(left: 18, top: 10, bottom: 10))),
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
                            passwordPreview = password;
                            previewPassword = true;
                          } else {
                            lockIcon = Icon(iconLocked);
                            passwordPreview = hidePassword(password_txt.text);
                            previewPassword = false;
                          }
                        });
                      },
                    )),
                    Expanded(child: 
                Padding(
                    padding: EdgeInsets.only(left: 6, top: 10, bottom: 10),
                    child: AutoSizeText(
                      passwordPreview,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      maxLines: 1,
                      minFontSize: 8,
                    ))),
                Padding(
                    padding: EdgeInsets.only(),
                    child: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: password));
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(LocalizationTool.of(context)
                                  .passwordCopied)));
                        }))
              ])), // PASSWORD PREVIEW
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
                  child: Text(
                    LocalizationTool.of(context).passwordGenSelect,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.yellow[300],
                          inactiveTrackColor: Colors.yellow[500],
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          thumbColor: Colors.yellow,
                          overlayColor: Colors.yellow.withAlpha(24),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.yellowAccent,
                          inactiveTickMarkColor: Colors.yellow,
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.yellowAccent,
                          valueIndicatorTextStyle:
                              TextStyle(color: Colors.black45),
                        ),
                        child: Slider(
                            value: _genChars,
                            min: charsMin,
                            max: 16,
                            label: '$_genChars',
                            divisions: (16 - charsMin.toInt()),
                            onChanged: (val) {
                              setState(() {
                                _genChars = val;
                              });
                            }))),
              ],
            )),
        // Password

        Row(children: <Widget>[
          Expanded(
              child: Padding(padding: EdgeInsets.all(14), child: _titleForm)),
        ]), // TITLE

        Row(children: <Widget>[
          Expanded(
              child: Padding(padding: EdgeInsets.all(20), child: _emailForm)),
        ]), // EMAIL

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
        Padding(
            padding: EdgeInsets.only(bottom: 30, left: 14, right: 14),
            child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: iconsChoice.length,
                    itemBuilder: (BuildContext context, int index) {
                      return IconChoice(iconsChoice[index], false);
                    }),
                height: 50)) // ICONS
      ],
    )));
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

  void onPasswordChange() {
    setState(() {
      password = password_txt.text;
      if (previewPassword) {
        passwordPreview = password;
      } else {
        passwordPreview = hidePassword(password_txt.text);
      }
    });
  }

  void createEntry(BuildContext context) async {
    String icon;
    password = generate_mode
        ? PassEntry.generatePass(_genChars.toInt())
        : password_txt.text;
    if (selected == null) {
      icon = IconChoiceState.emptyIconPath;
    } else {
      icon = selected.path;
    }
    PassEntry newEntry = PassEntry.withIcon(
        username, password, title, email, icon, tag, DateTime.now());

    if (_formKey.currentState.validate()) {
      ResultDialog dialog = ResultDialog("message");
      showDialog(context: context, builder: (context) => dialog);
      var pref = await SettingsManager.getPref(AutoSyncService.AutoSyncSetting)
          as bool;
      bool autoSyncPref = pref == null ? false : pref;
      await DBProvider.getDB()
          .addPassEntry(newEntry, isSyncDrive: autoSyncPref);
      HomePageState.changeDataset(() {
        HomePageState.Pairs.add(newEntry);
      });
      // INSERT ITEM ANIMATION
      var animatedListState = HomePageState.animatedListKey.currentState;
      if (animatedListState != null) {
        animatedListState.insertItem(HomePageState.Pairs.length - 1);
      }
      // EXPIRATION SETTING
      registerExpiration(newEntry);
      // AUTO SYNC SETTING

      // ADS
      AdManager.tryShowInterstitialAd();
      // DIALOG WITH A GREEN CHECK
      dialog.state.loaded();
    }
  }

  void assignSettings() async {
    var prefs = await SharedPreferences.getInstance();
    var temp = prefs.getDouble(ForYouSettingsTabState.charsAllowedKey);
    charsMin = temp == null ? 8 : temp;
    _genChars = charsMin;
    setState(() {});
  }

  void registerExpiration(PassEntry newEntry) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var daysDelay =
        prefs.getInt(NotificationSettingsTabState.passwordEntryExpiration);
    if (daysDelay == null) {
      daysDelay = 30;
    }
    var enabledNotifcations = await SettingsManager.getPref(
        NotificationSettingsTabState.notifcationsOn) as bool;
    if (enabledNotifcations != null && enabledNotifcations) {
      PassEntryExpiration(
              newEntry, newEntry.createdTime.add(Duration(days: daysDelay)))
          .scheduleNotification(context);
    }
  }
}

class IconChoice extends StatefulWidget {
  PassEntryIcon iconInfo;
  IconChoiceState state;

  bool _selected;
  @override
  State<StatefulWidget> createState() {
    return IconChoiceState(iconInfo, _selected);
  }

  IconChoice(PassEntryIcon icon, bool selected) {
    this.iconInfo = icon;
    this._selected = selected;
  }
}

class IconChoiceState extends State<IconChoice> {
  static List<PassEntryIcon> icons;
  static IconChoiceState selected;
  static String emptyIconPath = "assets/images/empty_icon.svg";
  PassEntryIcon iconInfo;
  bool isSelected = false;
  static IconChangedHandler _onChange;

  double _height = 50;

  double _width = 50;

  static void initOnChange(IChangedHandler<PassEntryIcon> onChanged) {
    _onChange = onChanged;
  }

  @override
  Widget build(BuildContext context) {
    if (this.isSelected) {
      IconChoiceState.selected = this;
    }
    var color = (isSelected) ? Colors.grey : Colors.transparent;
    return GestureDetector(
        child: AnimatedContainer(
          width: _width,
          height: _height,
          child: Container(
              child: SvgPicture.asset(iconInfo.path,
                  width: _width, height: _height),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: color))),
          duration: Duration(milliseconds: 200),
        ),
        onTap: () {
          setState(() {
            if (selected == this && this.isSelected) {
              selected._height = 50;
              selected._width = 50;
              isSelected = false;
              selected = null;
            } else {
              isSelected = !isSelected;
            }

            if (selected != null) {
              selected._height = 50;
              selected._width = 50;
              selected.setState(() {
                selected.isSelected = false;
              });
            }
            if (this.isSelected) {
              selected = this;
              _width = 80;
              _height = 80;
            } else {}

            _onChange.onChanged((selected == null)
                ? PassEntryIcon(emptyIconPath)
                : selected.iconInfo);
            setState(() {});
          });
        });
  }

  IconChoiceState(PassEntryIcon icon, bool selected) {
    this.iconInfo = icon;
    this.isSelected = selected;
  }
}

class IconChangedHandler implements IChangedHandler<PassEntryIcon> {
  IconChoiced newEntry;

  @override
  void onChanged(PassEntryIcon changed) {
    newEntry.selected = changed;
    newEntry.update();
  }

  IconChangedHandler(this.newEntry);
}

abstract class IChangedHandler<T> {
  void onChanged(T changed);
}

class PassEntryIcon {
  String path;

  PassEntryIcon(String path) {
    this.path = path;
  }
}

class TagHelper {
  static Widget widgetByTag(Tags tag, {Key key}) {
    Color color;
    switch (tag) {
      case Tags.red:
        color = Colors.redAccent;
        break;
      case Tags.green:
        color = Colors.lightGreenAccent;
        break;
      case Tags.yellow:
        color = Colors.yellowAccent;
        break;
      case Tags.orange:
        color = Colors.orangeAccent;
        break;
      case Tags.graphite:
        color = Color.fromARGB(255, 116, 122, 118);
        break;
      case Tags.white:
        color = Colors.white70;
        break;
    }
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  static List<PassEntry> sortByTags(List<PassEntry> initialList) {
    assert(initialList != null);

    var tags = Tags.values;
    List<PassEntry> result = [];
    for (var i = 0; i < tags.length; i++) {
      var addition =
      initialList.where((entry) => entry.tag == tags[i]).toList();
      result.addAll(addition);
    }
    return result;
  }
}
