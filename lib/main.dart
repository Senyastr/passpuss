import 'package:PassPuss/pages/homePage.dart';
import 'package:PassPuss/localization.dart';
import 'package:PassPuss/pages/recommendation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:PassPuss/Database.dart';
import "package:PassPuss/passentry.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:PassPuss/PassFieldItem.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'NewPassEntry.dart';

void main() => runApp(PassPuss());

class PassPuss extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          canvasColor: Color.fromARGB(255, 40, 40, 40)),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
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

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets

    return Scaffold(
      appBar: AppBar(title: Text(currentPageTitle)),
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
    );
  }

  @override
  void initState() {}

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
