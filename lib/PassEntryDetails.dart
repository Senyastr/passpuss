import 'package:PassPuss/passentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'localization.dart';

class PassEntryDetails extends StatefulWidget {
  PassEntry entry;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PassEntryDetailsState(entry);
  }

  PassEntryDetails(this.entry);
}

class PassEntryDetailsState extends State<PassEntryDetails> {
  PassEntry entry;
  Widget mainInfo;
  Widget timeBlock;

  Icon iconLocked;
  Icon iconOpened;

  var passwordShowState;
  var passwordStateKey = GlobalKey();
  var isPasswordShown = false;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    passwordShowState = Icon(Icons.lock, key: passwordStateKey, color: Theme
        .of(context)
        .accentColor);
    iconLocked = Icon(Icons.lock, key: passwordStateKey, color: Theme
        .of(context)
        .accentColor);
    iconOpened = Icon(Icons.lock_open, key: passwordStateKey, color: Theme
        .of(context)
        .accentColor);
    mainInfo = Column(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child:
              Padding(
                  padding: EdgeInsets.all(20),
                  child:
                  Text(
                    LocalizationTool
                        .of(context)
                        .details,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.white),
                  ))),
          Align(
              alignment: Alignment.topLeft,
              child: Row(children: <Widget>[
                Padding(
                    child: SvgPicture.asset(entry.getIconId()),
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                Text(entry.getTitle(),
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ])),
          Align(
              alignment: Alignment.bottomLeft,
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
                  child: Icon(Icons.person, color: Theme
                      .of(context)
                      .accentColor),
                ),
                Padding(
                    child: Text(entry.getUsername(),
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10))
              ])),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: IconButton(
                    icon: (isPasswordShown) ? iconOpened : iconLocked,
                    onPressed: () {
                      setState(() {
                        isPasswordShown = !isPasswordShown;
                      });
                    },
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  child: Text(
                      (isPasswordShown) ? entry.getPassword() : "******",
                      style: TextStyle(fontSize: 20, color: Colors.white))),
              Padding(
                  padding: EdgeInsets.all(1),
                  child: IconButton(
                      icon: Icon(Icons.content_copy, color: Theme
                          .of(context)
                          .accentColor),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: entry.getPassword()));
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "The password is copied to the clipboard.")));
                      })),
            ]),
          ),
        ]

    );
    timeBlock = Column(
      // TODO: put creation time, time to expire and so on fields here
        children: <Widget>[

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(20),
                child:
                Text(
                  LocalizationTool
                      .of(context)
                      .time,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white),
                )),
          ),
          AlignCenterLeft(
              Row(children: <Widget>[
                Icon(Icons.edit, color: Theme
                    .of(context)
                    .accentColor),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                      DateFormat(DateFormat.YEAR_MONTH_DAY).add_Hm().format(
                          entry.createdTime),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white)
                  ),)


              ]

              ),
              EdgeInsets.only(left: 20, top: 10,)
          )

        ]

    );
    var editButton = FloatingActionButton(
        onPressed: () {
          // TODO: implement the turn to the edit page
          // TODO: implement edit page
        },
        child: Icon(
            Icons.edit
        )
    );
    return Scaffold(
        body: SafeArea(child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child:
                  Text(
                    LocalizationTool
                        .of(context)
                        .passwordDetailsPage,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.white),
                  )),
            ),

            mainInfo,
            Divider(
                color: Colors.white
            ),
            timeBlock
          ],
        )
        ));
  }

  PassEntryDetailsState(this.entry);

  Widget AlignCenterLeft(Widget text, EdgeInsets insets) {
    return Padding(
      padding: insets,
      child: Align(
          alignment: Alignment.centerLeft,
          child: text
      ),
    );
  }
}
