import 'package:PassPuss/localization.dart';
import 'package:PassPuss/pages/editEntryPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:PassPuss/passentry.dart';
import 'Database.dart';
import 'package:PassPuss/pages/homePage.dart';

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
  TextFormField _passwordForm;
  TextFormField _usernameForm;
  TextFormField _titleForm;
  ListView icons;

  String username = "";
  String password = "";
  String previewPass = "";
  String title = "";

  bool generate_mode = false;

  double _sliderHeight = 0.0;

  double _genChars = 8;

  @override
  void initState() {
    selected = null;
    lockIcon = Icon(iconLocked);
    passwordPreview = "";
    IconChoiceState.initOnChange(new IconChangedHandler(this));
    IconChoiceState.icons = iconsChoice;
    IconChoiceState.selected = null;
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
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    _usernameForm = TextFormField(
      autovalidate: true,
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
    _passwordForm = TextFormField(
      enabled: !generate_mode,
      autovalidate: true,
      validator: (value) => password.length < 8
          ? LocalizationTool.of(context).newPasswordMore8Chars
          : null,
      controller: password_txt,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(Icons.lock),
          hintText: LocalizationTool.of(context).newPasswordFormHint,
          labelText: LocalizationTool.of(context).password),
    );
    _titleForm = TextFormField(
        autovalidate: true,
        validator: (val) => (val.isEmpty)
            ? LocalizationTool.of(context).newPasswordTitleNotEmpty
            : null,
        onChanged: (String changed) {
          setState(() {
            title = changed;
          });
        },
        key: _titleKey,
        decoration: InputDecoration(
            hintText: LocalizationTool.of(context).newPasswordTitleHint,
            labelText: LocalizationTool.of(context).title,
            icon: Icon(Icons.title)));
    password_txt.addListener(onPasswordChange);

    return Form(
        key: _formKey,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(LocalizationTool.of(context).createNewPassword),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () async {
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
                        username, password, title, icon, DateTime.now());

                      
                    if (_formKey.currentState.validate()) {
                      
                      await DBProvider.DB.addPassEntry(newEntry);
                      HomePageState.changeDataset(() {  
                        HomePageState.Pairs.add(newEntry);
                      });

                      
                      Navigator.pop<NewPassEntry>(context, this);
                    }
                  },
                )
              ],
            ),
            body: Column(children: <Widget>[
              Expanded(
                  child: Wrap(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(children: <Widget>[
                                  Padding(
                                      child: (IconChoiceState.selected != null)
                                          ? SvgPicture.asset(IconChoiceState
                                              .selected.iconInfo?.path)
                                          : SvgPicture.asset(
                                              IconChoiceState.emptyIconPath),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10)),
                                  Text("$title",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white))
                                ])), // ICON PREVIEW
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 27, top: 10, bottom: 10),
                                    child: Icon(Icons.person),
                                  ),
                                  Padding(
                                      child: Text(username,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                      padding: EdgeInsets.only(
                                          left: 18, top: 10, bottom: 10)),
                                  Padding(
                                      padding: EdgeInsets.all(1),
                                      child: IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            Clipboard.setData(
                                                ClipboardData(text: username));
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        LocalizationTool.of(
                                                                context)
                                                            .usernameCopied)));
                                          })),
                                ])), // USERNAME PREVIEW
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 15, bottom: 10, top: 10),
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
                                              passwordPreview = hidePassword(
                                                  password_txt.text);
                                              previewPassword = false;
                                            }
                                          });
                                        },
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 6, top: 10, bottom: 10),
                                      child: Text(passwordPreview,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white))),
                                  Padding(
                                      padding: EdgeInsets.only(),
                                      child: IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            Clipboard.setData(
                                                ClipboardData(text: password));
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        LocalizationTool.of(
                                                                context)
                                                            .passwordCopied)));
                                          }))
                                ])), // PASSWORD PREVIEW
                          ])))
                ],
              )),
              Expanded(
                child: SingleChildScrollView(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Wrap(children: <Widget>[
                          Card(
                              child: Center(
                                  child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(// Username
                                  children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.all(14),
                                        child: _usernameForm))
                              ]), // Username Field,
                              Row(children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.all(14),
                                        child: _passwordForm)),
                                IconButton(
                                    icon: Icon(Icons.lightbulb_outline,
                                        color: generate_mode
                                            ? Colors.yellow
                                            : Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        generate_mode = !generate_mode;
                                        _sliderHeight =
                                            generate_mode ? 100.0 : 0.0;
                                      });
                                    })
                              ]),
                              AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  height: _sliderHeight,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 17, top: 4),
                                        child: Text(
                                          LocalizationTool.of(context)
                                              .passwordGenSelect,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTrackColor:
                                                    Colors.yellow[300],
                                                inactiveTrackColor:
                                                    Colors.yellow[500],
                                                trackShape:
                                                    RoundedRectSliderTrackShape(),
                                                trackHeight: 4.0,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                        enabledThumbRadius:
                                                            12.0),
                                                thumbColor: Colors.yellow,
                                                overlayColor:
                                                    Colors.yellow.withAlpha(24),
                                                overlayShape:
                                                    RoundSliderOverlayShape(
                                                        overlayRadius: 28.0),
                                                tickMarkShape:
                                                    RoundSliderTickMarkShape(),
                                                activeTickMarkColor:
                                                    Colors.yellowAccent,
                                                inactiveTickMarkColor:
                                                    Colors.yellow,
                                                valueIndicatorShape:
                                                    PaddleSliderValueIndicatorShape(),
                                                valueIndicatorColor:
                                                    Colors.yellowAccent,
                                                valueIndicatorTextStyle:
                                                    TextStyle(
                                                        color: Colors.black45),
                                              ),
                                              child: Slider(
                                                  value: _genChars,
                                                  min: 8,
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
                              // Password
                              Row(children: <Widget>[
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.all(14),
                                        child: _titleForm)),
                              ]), // TITLE
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 30, left: 14, right: 14),
                                  child: Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: iconsChoice.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return IconChoice(
                                                iconsChoice[index], false);
                                          }),
                                      height: 50)) // ICONS
                            ],
                          )))
                        ]))),
              )
            ])));
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
        child: Container(
          child: SvgPicture.asset(iconInfo.path),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: color)),
        ),
        onTap: () {
          setState(() {
            if (selected == this && this.isSelected) {
              isSelected = false;
              selected = null;
            } else {
              isSelected = !isSelected;
            }

            if (selected != null) {
              selected.setState(() {
                selected.isSelected = false;
              });
            }
            if (this.isSelected) {
              selected = this;
            }
            _onChange.onChanged((selected == null)
                ? PassEntryIcon(emptyIconPath)
                : selected.iconInfo);
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
