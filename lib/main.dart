import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:PassPuss/Database.dart';
import "package:PassPuss/passentry.dart";
import 'package:flutter_svg/flutter_svg.dart';

import 'NewPassEntry.dart';

void main() => runApp(PassPuss());

class PassPuss extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
          primaryColor: new Color.fromARGB(255, 100, 150, 100),
          accentColor: new Color.fromARGB(255, 0, 142, 6),
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
  static List<PassEntry> Pairs = [];
  static PassEntriesPage _page;
  @override
  Widget build(BuildContext context) {
    _page = this;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets

    return Scaffold(
        appBar: AppBar(title: Text("HEY, THIS IS BAR")),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
                itemCount: Pairs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new PassField(Pairs[index]);
                  })),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewPassEntryPage()));
            },
          )
        ]));
  }

  @override
  void initState() {
    setState(() {
      assignPairs();
    });
  }

  assignPairs() async {
    var pairs = await DBProvider.DB.getPassEntries();
    setState(() {
      Pairs = pairs;
    });
  }

  static changeDataset(VoidCallback callback) {
    _page.setState(callback);
  }

  void Auth() async {
//    var localAuth = LocalAuthentication();
//    bool didAuthenticate =
//        await localAuth.authenticateWithBiometrics(
//        localizedReason: 'Please authenticate to show account balance');
  }


}
class PassField extends StatefulWidget{
  PassEntry passEntry;
  @override
  State<StatefulWidget> createState() {
    return PassFieldState(passEntry);
  }

  PassField(PassEntry passentry){
    this.passEntry = passentry;
  }

}
class PassFieldState extends State<PassField> {
  PassEntry passEntry;


  @override
  void initState() {
    command = SimpleRemove(passEntry);
    passwordShowState = Icon(Icons.lock, key: passwordStateKey);
    iconLocked = Icon(Icons.lock, key: passwordStateKey);
    iconOpened = Icon(Icons.lock_open, key: passwordStateKey);
  }
  Icon iconLocked;
  Icon iconOpened;

  PassFieldState(PassEntry entry) {
    this.passEntry = entry;
  }
  var passwordShowState;
  var passwordStateKey = GlobalKey();
  var isPasswordShown = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    printMethod();
    String imageName = passEntry.getIconId();
    initState();

    return new Padding(
        padding: EdgeInsets.only(left: 16, right:16, top:16),
        child: new Card(
            child: Column(children: <Widget>[
              Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                      children: <Widget>[
                        Padding(
                            child:
                            SvgPicture.asset(
                                passEntry.getIconId()),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10)),
                        Text(
                            passEntry.getTitle(),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                            )
                        )
                      ])),
          Align(
              alignment: Alignment.bottomLeft,
              child: Row(children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
                      child: Icon(Icons.person),
                ),
                Padding(
                  child: Text(passEntry.getUsername(),
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10))])),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 15,),
                        child:IconButton(
                            icon: (isPasswordShown) ?
                            iconOpened:
                            iconLocked,
                          onPressed: (){
                              setState((){
                                  isPasswordShown = !isPasswordShown;
                              });
                          },
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                        child:Text(
                            (isPasswordShown) ? passEntry.getPassword() : "******",
                            style: TextStyle(fontSize: 20, color: Colors.white)
                    )),
                    Padding(
                        padding: EdgeInsets.all(1),
                        child:IconButton(
                          icon: Icon(Icons.content_copy),
                          onPressed:(){
                          Clipboard.setData(ClipboardData(text: passEntry.getPassword()));
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("The password is copied to the clipboard.")
                          ));
                      }
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 60),
                        child:
                        Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.redAccent,
                                  size: 30
                              ),
                              onPressed: removeEntry,
                            )
                        )
                    )
                  ]
                ),

              ),

        ])));
  }

//  void printMethod() async {
//    String result = await MethodChannel("com.flutter.myapp/myapp").invokeMethod("MYMETHOD");
//    print(result);
// }
  RemoveCommand command;

  void removeEntry() {
    PassEntriesPage.changeDataset(() {
      PassEntriesPage.Pairs.remove(passEntry);
      DBProvider.DB.deletePassEntry(passEntry);
    });
  }


}

abstract class RemoveCommand {
  void remove();
}

class SimpleRemove<T extends StatefulWidget> extends RemoveCommand {
  PassEntry entry;

  SimpleRemove(this.entry);

  @override
  void remove() {
    PassEntriesPage.Pairs.remove(entry);
    DBProvider.DB.deletePassEntry(entry);
  }

}
