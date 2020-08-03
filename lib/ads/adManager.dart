import 'dart:io';

//class AdManager {
//  static String get appId {
//    if (Platform.isAndroid) {
//      return "ca-app-pub-4486341130353955~5840730523";
//    } else if (Platform.isIOS) {
//      throw UnsupportedError("Unsupported platform");
//    } else {
//      throw new UnsupportedError("Unsupported platform");
//    }
//  }
//
//  static String get bannerAdUnitId {
//    if (Platform.isAndroid) {
//      return "ca-app-pub-4486341130353955/7520751502";
//    } else if (Platform.isIOS) {
//      throw UnsupportedError("Unsupported platform");
//    } else {
//      throw new UnsupportedError("Unsupported platform");
//    }
//  }
//
//  static String get interstitialAdUnitId {
//    if (Platform.isAndroid) {
//      return "ca-app-pub-4486341130353955/5087828159";
//    } else if (Platform.isIOS) {
//      throw UnsupportedError("Unsupported platform");
//    } else {
//      throw new UnsupportedError("Unsupported platform");
//    }
//  }
//
//  static String get rewardedAdUnitId {
//    throw UnsupportedError("NOT REGISTERED");
//    if (Platform.isAndroid) {
//      return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
//    } else if (Platform.isIOS) {
//      return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
//    } else {
//      throw new UnsupportedError("Unsupported platform");
//    }
//  }
//}
class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544~4354546703";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~2594085930";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8865242552";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/7049598008";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3964253750";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8673189370";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/7552160883";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
