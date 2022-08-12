import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class RectBannerAd extends StatefulWidget {
  const RectBannerAd({Key? key}) : super(key: key);

  @override
  State createState() => _RectBannerAdState();
}

class _RectBannerAdState extends State<RectBannerAd> {
  AdSize size = AdSize.banner;
  late BannerAd _bannerAd;
  bool isReady = false;

  void initBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.rectBanner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          isReady = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        log('Banner ad Error $error');
      }),
    );
    _bannerAd.load();
  }

  @override
  void initState() {
    initBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return Container(
        width: size.width.toDouble(),
        height: 35,
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd),
      );
    }
    return const SizedBox();
  }
}
