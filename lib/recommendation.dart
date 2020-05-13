import 'package:flutter/material.dart';

import 'passentry.dart';

class RecommendationTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RecommendationTabState();
  }
}

class RecommendationTabState extends State<RecommendationTab> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    analyze();
    return null;
  }

  void analyze() {
    // TODO: Here we're getting RecommendationItems(passwords that should be changed)
    // TODO: Make a field for PassField with the date of creation
  }
}

class RecommendationItem extends StatefulWidget {
  String message;
  PassEntry entry;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RecommendationItemState(entry, message);
  }

  RecommendationItem();
}

class RecommendationItemState extends State<RecommendationTab> {
  String message;
  PassEntry entry;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  RecommendationItemState(this.entry, this.message);
}
