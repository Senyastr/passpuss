import 'package:PassPuss/passentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../Database.dart';
import '../NewPassEntry.dart';
import '../localization.dart';
import 'homePage.dart';

class EditEntryPage extends StatefulWidget {
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

  PassEntry entry;

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
    this.selected =
        iconsChoice.where((e) => e.path == entry.getIconId()).toList()[0];
            username_txt.text = entry.getUsername();
    password_txt.text = entry.getPassword();
    title_txt.text = entry.getTitle();
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
  final iconsChoice = [
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


    _usernameForm = TextFormField(
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
    _passwordForm = TextFormField(
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
    _titleForm = TextFormField(
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
    password_txt.addListener(onPasswordChanged);
    username_txt.addListener(onUsernameChanged);
    title_txt.addListener(onTitleChanged);

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
                    if (_formKey.currentState.validate()){
                      var newEntry = PassEntry.withIcon(username, password, title, selected.path, entry.createdTime);
                      await DBProvider.DB.deletePassEntry(entry);
                      HomePageState.Pairs.remove(entry);
                      await DBProvider.DB.addPassEntry(newEntry);
                      HomePageState.changeDataset(() { HomePageState.Pairs.add(newEntry);});
                      Navigator.popUntil(context, (route) => route.isFirst);
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
                                      child: (this.selected != null)
                                          ? SvgPicture.asset(this.selected.path)
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
                                      child: Text(username_txt.text,
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
                                            if (lockIcon.icon == iconLocked) {
                                              lockIcon = Icon(iconOpened);
                                              password_preview = password_txt.text;
                                              previewPassword = true;
                                            } else {
                                              lockIcon = Icon(iconLocked);
                                              password_preview = hiddenPassword;
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
                                                ClipboardData(text: password_txt.text));
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        LocalizationTool.of(
                                                                context)
                                                            .passwordCopied)));
                                          }))
                                ])), // password_password_txt.text PREVIEW
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
                                                  .passwordGenSelect)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: SliderTheme(
                                              data: SliderTheme.of(context)
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
                                                thumbColor: Colors.redAccent,
                                                overlayColor:
                                                    Colors.red.withAlpha(32),
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
                                                  }))),
                                    ],
                                  )),
                              // password_password_txt.text
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
                                      child: iconChoices, height: 50)) // ICONS
                            ],
                          )))
                        ]))),
              )
            ])));
  }

  void onPasswordChanged() {
    setState(() {
      password = password_txt.text;
      if (previewPassword) {
        password_preview = password_txt.text;
      }
    });
  }
  void onUsernameChanged(){
    
        setState(() {
           username = username_txt.text;
        });
      
  }

  void onTitleChanged(){
    setState((){
      title = title_txt.text;
    });
  }

  EditEntryState(this.entry);
}
