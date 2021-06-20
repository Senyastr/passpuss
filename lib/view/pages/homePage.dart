import 'package:PassPuss/logic/ads/adManager.dart';
import 'package:PassPuss/logic/localization.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:PassPuss/logic/Database.dart';
import 'package:PassPuss/logic/passentry.dart';
import 'package:PassPuss/view/PassFieldItem.dart';

import 'package:PassPuss/view/NewPassEntry.dart';
import 'package:tuple/tuple.dart';


abstract class Disposable {
  void dispose();
}

class HomePage extends StatefulWidget implements Disposable {
  HomePageState _state;
  @override
  State<StatefulWidget> createState() {
    _state = HomePageState();
    return _state;
  }

  void dispose() {
    _state.newPassEntryButtonKey.currentState.newEntryAnimationController
        .dispose();
    _state.dispose();
  }
}

enum InteractMode { def, searching }

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();
  static List<PassEntry> Pairs = [];
  static int viewItemsCount;
  static Sorts sortType = Sorts.none;
  static int sortIndex = 1;
  static HomePageState _page;

  // MODES OF INTERACTION WITH THE DATA
  // DEF - JUST SHOWING DATA
  // SEARCHING - SEARCHING FOR A SPECIFIC PIECE OF DATA
  InteractMode mode = InteractMode.def;
  List<PassField> passFieldsWidgets;
  GlobalKey<_NewPassEntryButtonState> newPassEntryButtonKey;
  String searchInquery;

  List<PassEntry> entriesFound = [];

  // TAGS
  Map<String, List<String>> iconTags;
  Map<Tags, String> tagsTags;

  @override
  void initState() {
    super.initState();
    assignPairs();
    newPassEntryButtonKey = GlobalKey<_NewPassEntryButtonState>();
    AdManager.initInterstitialAd();
    AdManager.loadInterstitialAd();
  }

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    _page = this;
    initFilterChoices(context);
    var construction = _buildContent();
    Widget upperPart = construction.item1;
    Widget content = construction.item2;
    if (loading){
       return Column(children: <Widget>[
      SafeArea(child: upperPart),
      Center(child: CircularProgressIndicator()),
    ]);
    
    }
    else{
      return Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
        SafeArea(child: upperPart),
        Expanded(child: SafeArea(child: Stack(children: [
          SizedBox(child: content),
          Align(alignment: Alignment.bottomRight, child: _buildNewEntryActionButton()),
        ]))),
      ]);
    }   
  }

  String timeSortName;
  String noneSortName;

  // upperpart, content
  Tuple2<Widget, Widget> _buildContent() {
    Widget upperPart;

    switch (mode) {
      case InteractMode.def:
        viewItemsCount = Pairs.length;
        upperPart = _buildDefUpperPart(context);

        break;
      case InteractMode.searching:
        viewItemsCount = entriesFound.length;
        upperPart = _buildSearchingUpperPart(context);
        break;
    }
    var listView = _buildListView(context);
    var content = Pairs.length == 0 ? _buildEmptyListView(context) : listView;
    return Tuple2<Widget, Widget>(upperPart, content);
  }

  Widget _buildListView(BuildContext context) {
    var pairs = filterChoices[sortIndex].sort(Pairs);
    return 
        mode == InteractMode.def
            ? AnimatedList(
                key: animatedListKey,
                initialItemCount: viewItemsCount,
                itemBuilder: (context, index, animation) {
                  return buildItem(pairs[index], animation);
                })
            : ListView.builder(
                itemCount: viewItemsCount,
                itemBuilder: (context, index) {
                  switch (mode) {
                    case InteractMode.def:
                      break;
                    case InteractMode.searching:
                      return PassField(entriesFound[index], GlobalKey());
                      break;
                    default:
                      return null;
                      break;
                  }
                  return null;
                },
              );
  }

  Widget _buildDefUpperPart(BuildContext context) {
    return Row(
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
                              .bodyText1
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
  }

  Widget _buildSearchingUpperPart(BuildContext context) {
    return SafeArea(
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
                                        color:
                                            Color.fromARGB(150, 255, 255, 255)),
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
  }

  Widget _buildEmptyListView(BuildContext context) {
    var flareActor = FlareActor(
      "assets/animations/lock.flr",
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      animation: 'loop',
    );
    return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 90),
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
                            LocalizationTool.of(context).passEntriesEmpty,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )));
  }

  Widget _buildNewEntryActionButton() {
    return NewPassEntryButton(key: newPassEntryButtonKey);
  }

  void assignPairs() async {
    loading = true;
    var pairs = await DBProvider.DB.getPassEntries((entries) {
      HomePageState.Pairs = entries;
    });
    setState(() {
      Pairs = pairs;
      loading = false;
    });
  }

  // SEARCH

  void searchUpdate(String changed) {
    searchInquery = changed;
    entriesFound = search(searchInquery.toLowerCase());
    setState(() {});
  }

  List<PassEntry> search(String inquery) {
    List<PassEntry> result = [];
    for (int i = 0; i < Pairs.length; i++) {
      var curPair = Pairs[i];
      if (concur(inquery, curPair)) {
        result.add(curPair);
      }
    }
    return result;
  }

  bool concur(String inquery, PassEntry entry) {
    if (iconTags == null) {
      initIconTags();
    }
    if (tagsTags == null) {
      initTagsTags();
    }
    var username = entry.getUsername().toLowerCase();
    var emailValue = entry.getEmail().toLowerCase();
    var email = emailValue == null ? "" : emailValue;
    var title = entry.getTitle().toLowerCase();
    var icon = entry.getIconId();
    var tag = entry.tag;
    var usernameConcur = username.contains(inquery);
    var emailConcur = email != "" ? email.contains(inquery) : false;
    var titleConcur = title.contains(inquery);
    return usernameConcur ||
        emailConcur ||
        titleConcur ||
        concurIcon(inquery, icon) ||
        concurTag(inquery, tag);
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

  bool concurTag(String inquery, Tags tag) {
    return tagsTags[tag].toLowerCase().contains(inquery);
  }

  void initIconTags() {
    iconTags = Map<String, List<String>>();
    var icons = NewPassEntry.iconsChoice;
    var language = LocalizationTool.of(context).locale.languageCode;
    for (var i = 0; i < icons.length; i++) {
      var curIcon = icons[i];
      // WHENEVER A NEW ICON IS ADDED TO NEW PASS ENTRY OR SOMEWHERE ELSE
      // U SHOULD ADD THAT ICON AND CORRESPONDING TAGS HERE
      switch (language) {
        case "en":
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
          break;

        case "ru":
          switch (curIcon.path) {
            case "assets/images/Instagram_logo_2016.svg":
              iconTags["assets/images/Instagram_logo_2016.svg"] = [
                "instagram",
                "photos",
                "videos",
                "фотки",
                "инстаграм",
                "видео",
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
                "watch",
                "епл",
                "айклауд",
                "мак",
                "айфон",
              ];
              break;
            case "assets/images/Google48x48.svg":
              iconTags["assets/images/Google48x48.svg"] = [
                "google",
                "mail",
                "gmail",
                "notes",
                "youtube",
                "calendar",
                "гугл",
                "почта",
                "записи",
                "календарь"
              ];
              break;
            case "assets/images/Spotify48x48.svg":
              iconTags["assets/images/Spotify48x48.svg"] = [
                "music",
                "spotify",
                "podcasts",
                "спотифай",
                "подкасты",
                "музыка"
              ];
              break;
            case "assets/images/Steam48x48.svg":
              iconTags["assets/images/Steam48x48.svg"] = [
                "games",
                "steam",
                "игры"
              ];
              break;
            case "assets/images/twitter-seeklogo.svg":
              iconTags["assets/images/twitter-seeklogo.svg"] = [
                "twitter",
                "tweets",
                "твиттер",
                "твиты"
              ];
              break;
            case "assets/images/Microsoft48x48.svg":
              iconTags["assets/images/Microsoft48x48.svg"] = [
                "microsoft",
                "windows",
                "виндовс",
                "пк",
              ];
              break;
            case "assets/images/Yandex_Browser_logo.svg":
              iconTags["assets/images/Yandex_Browser_logo.svg"] = [
                "yandex",
                "ydrive",
                "яндекс",
              ];
              break;
            case "assets/images/Creative_Cloud.svg":
              iconTags["assets/images/Creative_Cloud.svg"] = [
                "adobe",
                "cloud",
                "адоб",
                "фотошоп"
              ];
              break;
            case "assets/images/reddit copy.svg":
              iconTags["assets/images/reddit copy.svg"] = [
                "reddit",
                "news",
                "memes",
                "редит",
                "мемы"
              ];
              break;
            case "assets/images/Netflix_icon.svg":
              iconTags["assets/images/Netflix_icon.svg"] = [
                "movies",
                "tv shows",
                "netflix",
                "нетфликс",
                "фильмы",
                "сериалы",
              ];
              break;
          }
          break;
        case "ua":
          switch (curIcon.path) {
            case "assets/images/Instagram_logo_2016.svg":
              iconTags["assets/images/Instagram_logo_2016.svg"] = [
                "instagram",
                "photos",
                "videos",
                "фотки",
                "инстаграм",
                "видео",
                "інстаграм",
                "фото",
                "відео"
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
                "watch",
                "епл",
                "айклауд",
                "мак",
                "айфон",
              ];
              break;
            case "assets/images/Google48x48.svg":
              iconTags["assets/images/Google48x48.svg"] = [
                "google",
                "mail",
                "gmail",
                "notes",
                "youtube",
                "calendar",
                "гугл",
                "почта",
                "записи",
                "календарь"
              ];
              break;
            case "assets/images/Spotify48x48.svg":
              iconTags["assets/images/Spotify48x48.svg"] = [
                "music",
                "spotify",
                "podcasts",
                "спотифай",
                "подкасты",
                "подкасти",
                "музика"
              ];
              break;
            case "assets/images/Steam48x48.svg":
              iconTags["assets/images/Steam48x48.svg"] = [
                "games",
                "steam",
                "игры",
                "ігри"
              ];
              break;
            case "assets/images/twitter-seeklogo.svg":
              iconTags["assets/images/twitter-seeklogo.svg"] = [
                "twitter",
                "tweets",
                "твиттер",
                "твиты",
                "твіти",
                "твітер"
              ];
              break;
            case "assets/images/Microsoft48x48.svg":
              iconTags["assets/images/Microsoft48x48.svg"] = [
                "microsoft",
                "windows",
                "виндовс",
                "пк",
                "віндовс"
              ];
              break;
            case "assets/images/Yandex_Browser_logo.svg":
              iconTags["assets/images/Yandex_Browser_logo.svg"] = [
                "yandex",
                "ydrive",
                "яндекс",
              ];
              break;
            case "assets/images/Creative_Cloud.svg":
              iconTags["assets/images/Creative_Cloud.svg"] = [
                "adobe",
                "cloud",
                "адоб",
                "фотошоп",
              ];
              break;
            case "assets/images/reddit copy.svg":
              iconTags["assets/images/reddit copy.svg"] = [
                "reddit",
                "news",
                "memes",
                "редит",
                "редіт",
                "мемы",
                "меми"
              ];
              break;
            case "assets/images/Netflix_icon.svg":
              iconTags["assets/images/Netflix_icon.svg"] = [
                "movies",
                "tv shows",
                "netflix",
                "нетфликс",
                "фильмы",
                "сериалы",
                "серіали",
                "фільми",
                "кіно"
              ];
              break;
          }
      }
    }
  }

  void initTagsTags() {
    tagsTags = Map<Tags, String>();
    var tags = Tags.values;
    for (var i = 0; i < tags.length; i++) {
      var t = tags[i];

      tagsTags[t] = t.toString().split(".")[1];
    }
  }

  static Widget buildItem(PassEntry entry, Animation animation) {
    var field = PassField(entry, GlobalKey());
    return SlideTransition(
        position: animation
            .drive(Tween<Offset>(begin: Offset(200, 0), end: Offset.zero)),
        child: field);
  }

  static void changeDataset(VoidCallback callback) async {
    _page.loading = true;
    callback();
    Pairs = await DBProvider.DB.getPassEntries(null);
    _page.setState(() => _page.loading = false);
  }
}

List<SortOption> filterChoices;
void initFilterChoices(BuildContext context) {
  filterChoices = [
    SortOption(LocalizationTool.of(context).sortTags, (items) {
      return TagHelper.sortByTags(items);
    }, Icon(Icons.flag), Sorts.byTags),
    SortOption(LocalizationTool.of(context).sortTime, // "Sort by time"
        (items) {
      items.sort((a, b) => a.createdTime.compareTo(b.createdTime));
      return items;
    }, Icon(Icons.timer), Sorts.byTime),
    SortOption(LocalizationTool.of(context).sortNone, // "None",
        (items) {
      return items;
    }, Icon(Icons.cancel), Sorts.none),
  ];
}

enum Sorts {
  none,
  byTime,
  byTags,
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

class NewPassEntryButton extends StatefulWidget {
  NewPassEntryButton({Key key}) : super(key: key);

  @override
  _NewPassEntryButtonState createState() => _NewPassEntryButtonState();
}

class _NewPassEntryButtonState extends State<NewPassEntryButton>
    with SingleTickerProviderStateMixin {
  Animation newEntryAnimation;
  AnimationController newEntryAnimationController;
  initNewPassEntryAnimation() {
    var tween = Tween<double>(begin: 0, end: 50);
    newEntryAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    var curvedAnim = CurvedAnimation(
        parent: newEntryAnimationController, curve: Curves.easeOutSine);
    newEntryAnimation = tween.animate(curvedAnim)
      ..addListener(() {
        setState(() {});
      });

    newEntryAnimationController.forward();
    newEntryAnimationController.repeat(reverse: true);
  }

  @override
  void initState() {
    super.initState();
    initNewPassEntryAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 600),
            child: Padding(
                padding: EdgeInsets.only(bottom: newEntryAnimation.value),
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewPassEntryPage()));
                  },
                ))));
  }
}
