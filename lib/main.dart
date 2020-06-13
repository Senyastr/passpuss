import 'package:PassPuss/pages/homePage.dart';
import 'package:PassPuss/localization.dart';
import 'package:PassPuss/pages/recommendation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info/package_info.dart';

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

class PassEntriesPage extends State<MyHomePage> {
  int _selectedPageIndex = 0;
  static const TextStyle _bottomNavTextStyleDisabled =
      TextStyle(color: Colors.white);
  static const TextStyle _bottomNavTextStyleEnabled =
      TextStyle(color: Colors.red);

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Text home;
  Text forYou;
  List<Widget> pages = <Widget>[HomePage(), RecommendationTab()];
  List<BottomNavigationBarItem> bottomItems;

  String currentPageTitle = "";
  @override
  Widget build(BuildContext context) {
    home = Text(LocalizationTool.of(context).home);
    forYou = Text(LocalizationTool.of(context).forYou);
    bottomItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), title: home),
      BottomNavigationBarItem(icon: Icon(Icons.thumb_up), title: forYou)
    ];

    this.currentPageTitle = home.data;
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
                        onTap: () => showAboutDialog(
                          
                              context: context,
                              applicationVersion: PassPuss.appVersion,
                            ),
                        child: ListTile(
                            title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            VerticalDivider(),
                            Text(
                              LocalizationTool.of(context).aboutApp,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: Colors.white),
                            )
                          ],
                        ))))
              ],
            )));

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets
    var scaffold = Scaffold(
      appBar: AppBar(),
      key: scaffoldKey,
      body: pages.elementAt(_selectedPageIndex),
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
  }

  void Auth() async {
//    var localAuth = LocalAuthentication();
//    bool didAuthenticate =
//        await localAuth.authenticateWithBiometrics(
//        localizedReason: 'Please authenticate to show account balance');
  }

  void _onPageTapped(int value) {
    this._selectedPageIndex = value;
    this.currentPageTitle = (bottomItems[value].title as Text).data;
    setState(() {});
  }
}
