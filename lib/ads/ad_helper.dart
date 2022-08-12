class AdHelper {
  static const bool isTest = false;
  static String get applyAd {
    if (isTest) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }

    return 'ca-app-pub-2400508280875448/6220893765';
  }

  static String get rectBanner {
    if (isTest) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return 'ca-app-pub-2400508280875448/5582599517';
  }
}
