import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class ApplyAd {
  static InterstitialAd? _ad;
  static bool isAddReady = false;

  static void loadDoneAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.applyAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            isAddReady = true;
            _ad = ad;
          },
          onAdFailedToLoad: (error) {
            log('Error happened $error');
          },
        ));
  }

  static void hideAd() {
    _ad!.dispose();
  }

  static void showDoneAd() {
    if (isAddReady) {
      _ad!.show();
    }
  }
}
