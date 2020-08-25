import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ResultDialog extends StatefulWidget {
  String message;
  ResultType type;
  ResultDialog(this.message, {this.type});
  ResultDialogState state;
  @override
  State<StatefulWidget> createState() {
    state = ResultDialogState(message, type: this.type);
    return state;
  }
}

class ResultDialogState extends State<ResultDialog> {
  String message;
  ResultType type;

  bool _isLoaded = false;

  String _animationName;
  ResultDialogState(this.message, {this.type});

  void loaded() {
    this._isLoaded = true;
  }

  void onAnimationEnded(String name) {
    switch (type) {
      case ResultType.positive:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case ResultType.negative:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      default:
        if (_isLoaded) {
          type = ResultType.positive;
          setState(() {});
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    var image;
    if (type != null) {
      _isLoaded = true;
      switch (type) {
        case ResultType.positive:
          image = FlareActor(
            "assets/animations/success.flr",
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            animation: 'Untitled',
            callback: onAnimationEnded,
          );
          break;
        case ResultType.negative:
          image = FlareActor("assets/animations/failed.flr",
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              animation: 'activate',
              callback: onAnimationEnded);
          break;
      }
    } else {
      image = FlareActor("assets/animations/loading.flr",
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          animation: 'activate',
          callback: onAnimationEnded);
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
