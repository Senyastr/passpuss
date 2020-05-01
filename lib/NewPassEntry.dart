import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passpuss/passentry.dart';
import 'package:passpuss/main.dart';
import 'Database.dart';

class NewPassEntryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPassEntry();
  }
}

class NewPassEntry extends State<NewPassEntryPage> {
  final _usernameKey = GlobalKey();
  final _passwordKey = GlobalKey();
  TextFormField _passwordForm;
  TextFormField _usernameForm;
  ListView icons;

  String username = "";
  String password = "";
  String preview_password = "";

  String hiddenPassword = "*******";

  @override
  void initState() {
    lockIcon = Icon(iconLocked);
    password_preview = hiddenPassword;
  }
  bool previewPassword = false;
  Icon lockIcon;
  var iconLocked = Icons.lock;
  var iconOpened = Icons.lock_open;

  var passwordStateKey = GlobalKey();
  var isPasswordShown = false;
  var password_txt = TextEditingController();
  String password_preview;
  @override
  Widget build(BuildContext context) {

    _usernameForm = TextFormField(
      onChanged: (String changed) {
        setState(() {
          username = changed;
        });
      },
      key: _usernameKey,
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: "Your username/email/login",
          labelText: "Your username/email/login"),
    );
    _passwordForm = TextFormField(
      controller: password_txt,
      obscureText: true,
      key: _passwordKey,
      decoration: InputDecoration(
          icon: Icon(Icons.lock),
          hintText: "Your super-secure password",
          labelText: "Your super-secure password"),
    );
    password_txt.addListener(onPasswordChange);
    SvgPicture _DebugImage =
        SvgPicture.asset("assets/images/Instagram_logo_2016.svg");

    return Scaffold(
        appBar: AppBar(
          title: Text("Create new password entry"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                // TODO: Save entry
                PassEntry newEntry = new PassEntry.withIcon(
                    username,
                    password,
                    "Google",
                    "assets/images/Instagram_logo_2016.svg");
                PassEntriesPage.Pairs.add(newEntry);
                await DBProvider.DB.addPassEntry(newEntry);
                Navigator.pop<NewPassEntry>(context, this);
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
                  child: new Card(
                      child: Column(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            child: _DebugImage,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10))),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 27, top: 10, bottom: 10),
                            child: Icon(Icons.person),
                          ),
                          Padding(
                              child: Text(username,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 5))
                        ])),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 15, bottom: 10, top:10),
                              child: IconButton(
                                icon:
                                    lockIcon,
                                onPressed: () {
                                  setState(() {
                                    if (lockIcon.icon == iconLocked){
                                      lockIcon = Icon(iconOpened);
                                      password_preview = password;
                                      previewPassword = true;
                                    }
                                    else{
                                      lockIcon = Icon(iconLocked);
                                      password_preview = hiddenPassword;
                                      previewPassword = false;
                                    }
                                  });
                                },
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7),
                              child: Text(
                                  password_preview,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))),
                          Padding(
                              padding: EdgeInsets.only(),
                              child: IconButton(
                                  icon: Icon(Icons.content_copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: password));
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content:
                                        Text("Your password has been copied to the clipboard.")
                                        )
                                    );
                                  }))
                        ]))
                  ])))
            ],
          )),
          Expanded(
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
                                  padding: EdgeInsets.all(16),
                                  child: _usernameForm))
                        ]), // Username Field,
                        Row(children: <Widget>[
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: _passwordForm)),
                          IconButton(
                              icon: Icon(Icons.lightbulb_outline),
                              onPressed: () {
                                password_txt.text = PassEntry.generate_pass(8);
                              })
                        ]),
                      ],
                    )))
                  ])))
        ]));
  }
  void onPasswordChange() {
    setState(() {
      password = password_txt.text;
      if (previewPassword){
        password_preview = password;
      }
    });
  }
}
