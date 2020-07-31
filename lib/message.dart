import 'package:PassPuss/pages/homePage.dart';
import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/cache.dart';
import 'package:flare_flutter/cache_asset.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/flare_cache_asset.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flare_flutter/flare_render_box.dart';
import 'package:flare_flutter/flare_testing.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flare_flutter/provider/memory_flare.dart';
import 'package:flutter/material.dart';

import 'localization.dart';

class ResultDialog extends StatefulWidget {
  String message;
  ResultType type;
  ResultDialog(this.message, this.type);

  @override
  State<StatefulWidget> createState() {
    return ResultDialogState(message, this.type);
  }
}

class ResultDialogState extends State<ResultDialog> {
  String message;
  ResultType type;
  ResultDialogState(this.message, this.type);

  @override
  Widget build(BuildContext context) {
    var image;
    switch (type) {
      case ResultType.positive:
        image = FlareActor(
          "assets/animations/success.flr",
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          animation: 'Untitled',
          callback: (name) =>
              Navigator.popUntil(context, (route) => route.isFirst),
        );
        break;
      case ResultType.negative:
        image = FlareActor(
          "assets/animations/failed.flr",
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          animation: 'activate',
          callback: (name) =>
              Navigator.popUntil(context, (route) => route.isFirst),
        );
        break;
    }
    return Material(
        type: MaterialType.transparency,
        child: Dialog(
            child: SafeArea(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                  child: Container(width: 200, height: 200, child: image))),
        ]))));
  }
}

enum ResultType { positive, negative }
