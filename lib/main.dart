import 'package:PassPuss/pages/homePage.dart';
import 'package:PassPuss/localization.dart';
import 'package:PassPuss/pages/recommendation.dart';
import 'package:PassPuss/pages/settings/Privacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:PassPuss/auth/local_auth.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'message.dart';
import 'pages/settings/settings.dart';

void main() => runApp(PassPuss());

class PassPuss extends StatelessWidget {
  // This widget is the root of your application.

  static String packageName;
  static String appName;
  static String appVersion;
  static String appBuildNumber;
  @override
  Widget build(BuildContext context) {
    assignInfo();

    return MaterialApp(
      localizationsDelegates: [
        const PassPussLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ru', 'RU'),
      ],
      title: 'Pass Puss',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color.fromARGB(255, 100, 150, 100),
        accentColor: Color.fromARGB(255, 0, 142, 6),
        cardColor: Color.fromARGB(255, 70, 70, 70),
        backgroundColor: Color.fromARGB(255, 40, 40, 40),
        canvasColor: Color.fromARGB(255, 40, 40, 40),
        dividerColor: Color.fromARGB(225, 82, 172, 117),
        // APPLY THIS THEME TO EVERY TEXT ELEMENT
        accentTextTheme: TextTheme(
          headline1: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white70,
              decoration: TextDecoration.none),
          headline2: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white70,
              decoration: TextDecoration.none),
          headline3: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white70,
              decoration: TextDecoration.none),
          headline4: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white70,
              decoration: TextDecoration.none),
          headline5: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white,
              decoration: TextDecoration.none),
          headline6: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white,
              decoration: TextDecoration.none),
          subtitle1: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white,
              decoration: TextDecoration.none),
          bodyText1: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white,
              decoration: TextDecoration.none),
          bodyText2: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white,
              decoration: TextDecoration.none),
          caption: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white70,
              decoration: TextDecoration.none),
          button: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white,
              decoration: TextDecoration.none),
          subtitle2: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white,
              decoration: TextDecoration.none),
          overline: TextStyle(
              fontFamily: 'NotoSans',
              inherit: true,
              color: Colors.white,
              decoration: TextDecoration.none),
        ),
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 40, 40, 40),
        ),
        dialogBackgroundColor: Color.fromARGB(255, 40, 40, 40),
        dialogTheme: DialogTheme(
            titleTextStyle: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white),
            contentTextStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white)),
      ),
      home: MyHomePage(),
    );
  }

  void assignInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    appVersion = packageInfo.version;
    appBuildNumber = packageInfo.buildNumber;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  PassEntriesPage createState() => PassEntriesPage();
}

class PassEntriesPage extends State<MyHomePage> implements ResetAuthAction {
  int _selectedPageIndex = 0;
  static const TextStyle _bottomNavTextStyleDisabled =
      TextStyle(color: Colors.white);
  static const TextStyle _bottomNavTextStyleEnabled =
      TextStyle(color: Colors.red);

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Text home;
  Text forYou;
  List<Widget> pages = <Widget>[
    HomePage(),
    RecommendationTab(),
  ];
  List<BottomNavigationBarItem> bottomItems;
  String currentPageTitle = "";
  var infoIcon = Icon(
    Icons.info,
    color: Colors.white,
  );
  bool isAuth = true;
  @override
  Widget build(BuildContext context) {
    home = Text(LocalizationTool.of(context).home);
    forYou = Text(LocalizationTool.of(context).forYou);
    bottomItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), title: home),
      BottomNavigationBarItem(icon: Icon(Icons.thumb_up), title: forYou)
    ];
    this.currentPageTitle = home.data;

    var drawerTextStyle =
        Theme.of(context).textTheme.headline5.copyWith(color: Colors.white);
    var drawer = Drawer(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => SettingsPage()));
                        },
                        child: ListTile(
                            title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            VerticalDivider(),
                            Text(
                              LocalizationTool.of(context).settings,
                              style: drawerTextStyle,
                            ),
                          ],
                        )))),
                Center(
                    child: GestureDetector(
                        onTap: () => showAboutDialog(
                              context: context,
                              applicationVersion: PassPuss.appVersion,
                            ),
                        child: ListTile(
                            title: Row(
                          children: <Widget>[
                            infoIcon,
                            VerticalDivider(),
                            Text(
                              LocalizationTool.of(context).aboutApp,
                              style: drawerTextStyle,
                            )
                          ],
                        )))),
              ],
            )));

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets
    if (!isAuth) {
      Auth();
    }

    var scaffold = Scaffold(
      appBar: AppBar(),
      key: scaffoldKey,
      body: isAuth
          ? pages.elementAt(_selectedPageIndex)
          : NotAuthenticatedWidget(this),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomItems,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.green,
        onTap: _onPageTapped,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: _bottomNavTextStyleEnabled,
        unselectedLabelStyle: _bottomNavTextStyleDisabled,
      ),
      drawer: drawer,
    );
    return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            scaffoldKey.currentState.openDrawer();
          }
        },
        child: scaffold);
  }

  @override
  void initState() {
    super.initState();
    isAuth = false;
  }

  // ignore: non_constant_identifier_names
  void Auth() async {
    if (await mustAuth()) {
      var localAuth = LocalAuthentication();
      bool hasAuthenticated = await localAuth.authenticateWithBiometrics(
          localizedReason: LocalizationTool.of(context).fingerprintLogin,
          stickyAuth: true);
      setState(() => isAuth = hasAuthenticated);
    } else {
      setState(() => isAuth = true);
    }
  }

  void _onPageTapped(int value) {
    this._selectedPageIndex = value;
    this.currentPageTitle = (bottomItems[value].title as Text).data;
    setState(() {});
  }

  Future<bool> mustAuth() async {
    var option =
        await SettingsManager.getPref(PrivacySettingsTabState.isVerifyingKey);
    var result = option as bool;
    return result == null ? false : result;
  }

  @override
  onResetAuth() {
    Auth();
  }
}

class NotAuthenticatedWidget extends StatefulWidget {
  ResetAuthAction callback;
  NotAuthenticatedWidget(this.callback);
  @override
  _NotAuthenticatedWidgetState createState() =>
      _NotAuthenticatedWidgetState(callback);
}

class _NotAuthenticatedWidgetState extends State<NotAuthenticatedWidget> {
  String userCode;
  ResetAuthAction callback;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isWrong = true;
  int tries = 0;
  _NotAuthenticatedWidgetState(this.callback);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Form(
            key: key,
            child: Column(
              children: <Widget>[
                Icon(Icons.warning, color: Colors.redAccent, size: 72),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      LocalizationTool.of(context).notAuthText,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.redAccent),
                    )),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      onChanged: (String v) {
                        userCode = v;
                      },
                      validator: (value) {
                        if (isWrong) {
                          // TODO: FIX IT
                          tries++;
                          var triesRemaining = (3 - tries);
                          if (triesRemaining == 0) {
                            return "Try again later.";
                          } else {
                            return "The code is wrong. Try again. " +
                                triesRemaining.toString() +
                                " try/tries remaining.";
                          }
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock,
                            color: Theme.of(context).accentColor),
                        hintText: LocalizationTool.of(context).typeBackupCode,
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      child: Text(LocalizationTool.of(context).proceed),
                      color: Colors.greenAccent,
                      onPressed: () async {
                        if (tries < 3) {
                          var prefs = (await SharedPreferences.getInstance());
                          var code = prefs.getString(
                              FingerprintBackupState.backupKeySetting);
                          if (code == userCode) {
                            prefs.setBool(
                                PrivacySettingsTabState.isVerifyingKey, false);
                            showDialog(
                              context: context,
                              builder: (context) => ResultDialog("msg", ResultType.positive),
                            );
                            callback.onResetAuth();
                            // msg isn't used
                          } else {
                            isWrong = true;
                            key.currentState.validate();
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            )));
  }
}

class ResetAuthAction {
  onResetAuth() {}
}
