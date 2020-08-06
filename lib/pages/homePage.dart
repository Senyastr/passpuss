import 'dart:isolate';

import 'package:PassPuss/ads/adManager.dart';
import 'package:PassPuss/localization.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:PassPuss/Database.dart';
import "package:PassPuss/passentry.dart";
import 'package:PassPuss/PassFieldItem.dart';

import 'package:PassPuss/NewPassEntry.dart';
import 'package:tuple/tuple.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

enum InteractMode { def, searching }

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static List<PassEntry> Pairs = [];
  static Sorts sortType = Sorts.none;
  static int sortIndex = 1;
  static HomePageState _page;

  List<PassField> passFieldsWidgets;
  InteractMode mode = InteractMode.def;

  String searchInquery;

  List<PassEntry> entriesFound = List<PassEntry>();

  int viewItemsCount;

  @override
  void initState() {
    super.initState();
    assignPairs();

    AdManager.initInterstitialAd();
    AdManager.loadInterstitialAd();
  }

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    _page = this;
    var construction = buildContent();
    Widget upperPart = construction.item1;
    Widget content = construction.item2;

    return Column(children: <Widget>[
      SafeArea(child: upperPart),
      !loading ? content : Center(child: CircularProgressIndicator()),
      loading
          ? Container()
          : Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewPassEntryPage()));
                },
              )),
    ]);
  }

  List<SortOption> filterChoices = [
    SortOption("Sort by time", (items) {
      // TODO: localize string
      items.sort((a, b) => a.createdTime.compareTo(b.createdTime));
      return items;
    }, Icon(Icons.timer), Sorts.byTime),
    SortOption("None", (items) {
      // TODO: Localize string
      return items;
    }, Icon(Icons.cancel), Sorts.none),
  ];
  // upperpart, content
  Tuple2<Widget, Widget> buildContent() {
    var flareActor = FlareActor(
      "assets/animations/lock.flr",
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      animation: 'loop',
    );

    var upperPart;
    var pairs = filterChoices[sortIndex].sort(Pairs);

    switch (mode) {
      case InteractMode.def:
        viewItemsCount = Pairs.length;
        upperPart = Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        LocalizationTool.of(context).home,
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ))),
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                          width: 20,
                          height: 18,
                          child: Text(Pairs.length.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.white)),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle,
                          ))),
                  Pairs.length != 0
                      ? Row(children: [
                          PopupMenuButton(
                            onSelected: (value) {
                              sortType = filterChoices[value].sortType;
                              sortIndex = value;
                              setState(() {});
                            },
                            child: Icon(Icons.sort, color: Colors.white),
                            color: Colors.white,
                            itemBuilder: (BuildContext context) {
                              return filterChoices.map((item) {
                                return PopupMenuItem(
                                  child: ListTile(
                                    leading: item.icon,
                                    title: Text(item.name),
                                    contentPadding: EdgeInsets.all(1),
                                  ),
                                  value: filterChoices.indexOf(item),
                                );
                              }).toList();
                            },
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: IconButton(
                                  icon: Icon(Icons.search, color: Colors.white),
                                  onPressed: () {
                                    mode = InteractMode.searching;
                                    setState(() {});
                                  },
                                ),
                              ))
                        ])
                      : Container(),
                ],
              ),
            ]);
            

        break;
      case InteractMode.searching:
        viewItemsCount = entriesFound.length;
        upperPart = SafeArea(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                    child: Row(
                  children: <Widget>[
                    Expanded(
                        child: FocusScope(
                            child: TextField(
                                autofocus: true,
                                onChanged: searchUpdate,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Color.fromARGB(
                                                150, 255, 255, 255)),
                                    hintText: LocalizationTool.of(context)
                                        .entrySearchHint,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                    ))))),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon: Icon(Icons.cancel, color: Colors.white),
                          onPressed: () {
                            mode = InteractMode.def;
                            setState(() {});
                          },
                        ))
                  ],
                ))));
        break;
    }
            var content = Pairs.length == 0
            ? Expanded(
                child: SafeArea(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 90),
                                    child: TweenAnimationBuilder(
                                      curve: Curves.easeIn,
                                      builder: (_, double pos, __) {
                                        return Transform.translate(
                                            offset: Offset(pos, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Center(
                                                    child: Container(
                                                        width: 80,
                                                        height: 80,
                                                        child: flareActor)),
                                                Center(
                                                  child: Icon(Icons.list,
                                                      size: 100,
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                )
                                              ],
                                            ));
                                      },
                                      duration: Duration(milliseconds: 300),
                                      tween: Tween<double>(begin: -200, end: 0),
                                    )),
                                Center(
                                  child: Text(
                                    LocalizationTool.of(context)
                                        .passEntriesEmpty,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )))))
            : Expanded(
                child: ListView.builder(
                    itemCount: viewItemsCount,
                    itemBuilder: (context, index) {
                      switch (mode) {
                        case InteractMode.def:
                        
                        return PassField(pairs[index], GlobalKey());
                          
                          break;
                        case InteractMode.searching:
                          return PassField(entriesFound[index], GlobalKey());
                          break;
                        default:
                          return null;
                      }
                    }));
    return Tuple2<Widget, Widget>(upperPart, content);
  }

  assignPairs() async {
    loading = true;
    var pairs = await DBProvider.DB.getPassEntries();
    setState(() {
      Pairs = pairs;
      loading = false;
    });
  }

  static changeDataset(VoidCallback callback) {
    _page.loading = true;
    callback();
    _page.setState(() => _page.loading = false);
  }

  // SEARCH

  void searchUpdate(String changed) {
    searchInquery = changed;
    entriesFound = search(searchInquery.toLowerCase());
    setState(() {});
  }

  List<PassEntry> search(String inquery) {
    List<PassEntry> result = List<PassEntry>();
    for (int i = 0; i < Pairs.length; i++) {
      var curPair = Pairs[i];
      if (concur(inquery, curPair)) {
        result.add(curPair);
      }
    }
    return result;
  }

  Map<String, List<String>> iconTags;

  bool concur(String inquery, PassEntry entry) {
    if (iconTags == null) {
      initIconTags();
    }
    var username = entry.getUsername().toLowerCase();
    var emailValue = entry.getEmail().toLowerCase();
    var email = emailValue == null ? "" : emailValue;
    var title = entry.getTitle().toLowerCase();
    var icon = entry.getIconId();
    var usernameConcur = username.contains(inquery);
    var emailConcur = email != "" ? email.contains(inquery) : false;
    var titleConcur = title.contains(inquery);
    return usernameConcur ||
        emailConcur ||
        titleConcur ||
        concurIcon(inquery, icon);
  }

  bool concurIcon(String inquery, String iconPath) {
    if (iconTags.containsKey(iconPath)) {
      var tags = iconTags[iconPath];
      for (var v in tags) {
        if (v.contains(inquery)) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  void initIconTags() {
    iconTags = Map<String, List<String>>();
    var icons = NewPassEntry.iconsChoice;
    for (var i = 0; i < icons.length; i++) {
      var curIcon = icons[i];
      // WHENEVER A NEW ICON IS ADDED TO NEW PASS ENTRY OR SOMEWHERE ELSE
      // U SHOULD ADD THAT ICON AND CORRESPONDING TAGS HERE
      switch (curIcon.path) {
        case "assets/images/Instagram_logo_2016.svg":
          iconTags["assets/images/Instagram_logo_2016.svg"] = [
            "instagram",
            "photos",
            "videos"
          ];
          break;
        case "assets/images/Facebook_logo_24x24.svg":
          iconTags["assets/images/Facebook_logo_24x24.svg"] = ["facebook"];
          break;
        case "assets/images/Apple48x48.svg":
          iconTags["assets/images/Apple48x48.svg"] = [
            "apple",
            "icloud",
            "mac",
            "iphone",
            "ipad",
            "macos",
            "watch"
          ];
          break;
        case "assets/images/Google48x48.svg":
          iconTags["assets/images/Google48x48.svg"] = [
            "google",
            "mail",
            "gmail",
            "notes",
            "youtube",
            "calendar"
          ];
          break;
        case "assets/images/Spotify48x48.svg":
          iconTags["assets/images/Spotify48x48.svg"] = [
            "music",
            "spotify",
            "podcasts"
          ];
          break;
        case "assets/images/Steam48x48.svg":
          iconTags["assets/images/Steam48x48.svg"] = ["games", "steam"];
          break;
        case "assets/images/twitter-seeklogo.svg":
          iconTags["assets/images/twitter-seeklogo.svg"] = [
            "twitter",
            "tweets"
          ];
          break;
        case "assets/images/Microsoft48x48.svg":
          iconTags["assets/images/Microsoft48x48.svg"] = [
            "microsoft",
            "windows"
          ];
          break;
        case "assets/images/Yandex_Browser_logo.svg":
          iconTags["assets/images/Yandex_Browser_logo.svg"] = [
            "yandex",
            "ydrive"
          ];
          break;
        case "assets/images/Creative_Cloud.svg":
          iconTags["assets/images/Creative_Cloud.svg"] = ["adobe", "cloud"];
          break;
        case "assets/images/reddit copy.svg":
          iconTags["assets/images/reddit copy.svg"] = [
            "reddit",
            "news",
            "memes"
          ];
          break;
        case "assets/images/Netflix_icon.svg":
          iconTags["assets/images/Netflix_icon.svg"] = [
            "movies",
            "tv shows",
            "netflix"
          ];
          break;
      }
    }
  }
}

enum Sorts {
  none,
  byTime,
}
typedef SortItems<T1> = List<T1> Function(List<T1> value);

class SortOption<T> {
  SortItems<PassEntry> sort;
  String name;
  Icon icon;

  Sorts sortType;
  SortOption(this.name, this.sort, this.icon, this.sortType);
  List<PassEntry> sortItems(List<PassEntry> items) {
    return sort(items);
  }
}
