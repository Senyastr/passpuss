import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:PassPuss/passentry.dart';
import 'package:PassPuss/main.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'Database.dart';
import 'homePage.dart';

class NewPassEntryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPassEntry();
  }
}

class NewPassEntry extends State<NewPassEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey();
  final _passwordKey = GlobalKey();
  final _titleKey = GlobalKey();
  TextFormField _passwordForm;
  TextFormField _usernameForm;
  TextFormField _titleForm;
  ListView icons;

  String username = "";
  String password = "";
  String preview_password = "";
  String title = "";

  String hiddenPassword = "*******";

  bool generate_mode = false;

  double _sliderHeight = 0.0;

  double _genChars = 8;

  @override
  void initState() {
    selected = null;
    lockIcon = Icon(iconLocked);
    password_preview = hiddenPassword;
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
  var iconsChoice = [
    PassEntryIcon("assets/images/Instagram_logo_2016.svg"),
    PassEntryIcon("assets/images/Facebook_logo_24x24.svg"),
    PassEntryIcon("assets/images/Apple48x48.svg"),
    PassEntryIcon("assets/images/Google48x48.svg"),
    PassEntryIcon("assets/images/Spotify48x48.svg"),
    PassEntryIcon("assets/images/Steam48x48.svg"),
    PassEntryIcon("assets/images/twitter-seeklogo.svg"),
    PassEntryIcon("assets/images/Microsoft48x48.svg"),
  ];
  String password_preview;

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    _usernameForm = TextFormField(
      autovalidate: true,
      validator: (value) =>
      username.isEmpty ? 'Username shouldn\'t be blank' : null,
      onChanged: (String changed) {
        setState(() {
          username = changed;
        });
      },
      key: _usernameKey,
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: "Your username/email/login",
          labelText: "Username/email/login"),
    );
    _passwordForm = TextFormField(
      enabled: !generate_mode,
      autovalidate: true,
      validator: (value) =>
      password.length < 8
          ? 'Password should have more than 8 characters'
          : null,
      controller: password_txt,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(Icons.lock),
          hintText: "Your super-secure password",
          labelText: "Password"),
    );
    _titleForm = TextFormField(
        autovalidate: true,
        validator: (val) => (val.isEmpty) ? "Title shouldn't be empty." : null,
        onChanged: (String changed) {
          setState(() {
            title = changed;
          });
        },
        key: _titleKey,
        decoration: InputDecoration(
            hintText: "Write something specific to this entry",
            labelText: "Title",
            icon: Icon(Icons.title)));
    password_txt.addListener(onPasswordChange);

    return Form(
        key: _formKey,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text("Create new password entry"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () async {
                    String icon;
                    password = generate_mode
                        ? PassEntry.generate_pass(_genChars.toInt())
                        : password_txt.text;
                    if (selected == null) {
                      icon = IconChoiceState.emptyIconPath;
                    } else {
                      icon = selected.path;
                    }
                    PassEntry newEntry =
                    new PassEntry.withIcon(username, password, title, icon);
                    // TODO: Save entry

                    if (_formKey.currentState.validate()) {
                      HomePageState.Pairs.add(newEntry);
                      await DBProvider.DB.addPassEntry(newEntry);
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
                                          child: (IconChoiceState.selected !=
                                              null)
                                              ? SvgPicture.asset(IconChoiceState
                                              .selected.iconInfo?.path)
                                              : SvgPicture.asset(
                                              IconChoiceState.emptyIconPath),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10)),
                                      Text("$title",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white))
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 5))
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
                                                if (lockIcon.icon ==
                                                    iconLocked) {
                                                  lockIcon = Icon(iconOpened);
                                                  password_preview = password;
                                                  previewPassword = true;
                                                } else {
                                                  lockIcon = Icon(iconLocked);
                                                  password_preview =
                                                      hiddenPassword;
                                                  previewPassword = false;
                                                }
                                              });
                                            },
                                          )),
                                      Padding(
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 7),
                                          child: Text(password_preview,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white))),
                                      Padding(
                                          padding: EdgeInsets.only(),
                                          child: IconButton(
                                              icon: Icon(Icons.content_copy),
                                              onPressed: () {
                                                Clipboard.setData(
                                                    ClipboardData(
                                                        text: password));
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Your password has been copied to the clipboard.")));
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[
                                      Row( // Username
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
                                                  padding: EdgeInsets.only(
                                                      left: 17, top: 4),
                                                  child: Text(
                                                      "Select how many characters your password is going to consist of.")),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 4),
                                                  child: SliderTheme(
                                                      data: SliderTheme.of(
                                                          context)
                                                          .copyWith(
                                                        activeTrackColor:
                                                        Colors.red[700],
                                                        inactiveTrackColor:
                                                        Colors.red[100],
                                                        trackShape:
                                                        RoundedRectSliderTrackShape(),
                                                        trackHeight: 4.0,
                                                        thumbShape:
                                                        RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                            12.0),
                                                        thumbColor: Colors
                                                            .redAccent,
                                                        overlayColor:
                                                        Colors.red.withAlpha(
                                                            32),
                                                        overlayShape:
                                                        RoundSliderOverlayShape(
                                                            overlayRadius: 28.0),
                                                        tickMarkShape:
                                                        RoundSliderTickMarkShape(),
                                                        activeTickMarkColor:
                                                        Colors.red[700],
                                                        inactiveTickMarkColor:
                                                        Colors.red[100],
                                                        valueIndicatorShape:
                                                        PaddleSliderValueIndicatorShape(),
                                                        valueIndicatorColor:
                                                        Colors.redAccent,
                                                        valueIndicatorTextStyle:
                                                        TextStyle(
                                                          color: Colors.white,
                                                        ),
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
                                                          }))
                                              ),

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
                                                  scrollDirection: Axis
                                                      .horizontal,
                                                  itemCount: iconsChoice.length,
                                                  itemBuilder: (
                                                      BuildContext context,
                                                      int index) {
                                                    return IconChoice(
                                                        iconsChoice[index]);
                                                  }),
                                              height: 50)) // ICONS
                                    ],
                                  )))
                        ]))),
              )
            ])));
  }

  void onPasswordChange() {
    setState(() {
      password = password_txt.text;
      if (previewPassword) {
        password_preview = password;
      }
    });
  }
}

class IconChoice extends StatefulWidget {
  PassEntryIcon iconInfo;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IconChoiceState(iconInfo);
  }

  IconChoice(PassEntryIcon icon) {
    this.iconInfo = icon;
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

  IconChoiceState(this.iconInfo);
}

class IconChangedHandler implements IChangedHandler<PassEntryIcon> {
  NewPassEntry newEntry;

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
