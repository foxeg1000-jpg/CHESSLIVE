import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:chess_live/app/config/app_config.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  late BannerAd _bannerAd;
  late InterstitialAd? _interstitialAd;
  bool _isBannerLoaded = false;
  bool _isInterstitialLoaded = false;

  factory AdManager() {
    return _instance;
  }

  AdManager._internal();

  // Get banner ad unit ID based on platform
  String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.androidBannerId;
    } else if (Platform.isIOS) {
      return AppConfig.iosBannerId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  // Get interstitial ad unit ID based on platform
  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.androidInterstitialId;
    } else if (Platform.isIOS) {
      return AppConfig.iosInterstitialId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  // Initialize Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // Load banner ad
  Future<void> loadBannerAd() async {
    try {
      _bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            _isBannerLoaded = true;
          },
          onAdFailedToLoad: (ad, error) {
            print('Banner ad failed to load: ${error.message}');
            ad.dispose();
            // Retry after 5 seconds
            Future.delayed(Duration(seconds: 5), loadBannerAd);
          },
          onAdOpened: (_) {
            print('Banner ad opened');
          },
          onAdClosed: (_) {
            print('Banner ad closed');
          },
        ),
      );

      await _bannerAd.load();
    } catch (e) {
      print('Error loading banner ad: $e');
    }
  }

  // Load interstitial ad with retry logic
  Future<void> loadInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isInterstitialLoaded = true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('Interstitial ad failed to load: ${error.message}');
            _isInterstitialLoaded = false;
            // Retry after 5 seconds
            Future.delayed(Duration(seconds: 5), loadInterstitialAd);
          },
        ),
      );
    } catch (e) {
      print('Error loading interstitial ad: $e');
    }
  }

  // Show banner ad widget
  Widget getBannerAdWidget() {
    if (!_isBannerLoaded) {
      return SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }

  // Show interstitial ad
  Future<void> showInterstitialAd() async {
    if (!_isInterstitialLoaded || _interstitialAd == null) {
      print('Interstitial ad not loaded yet');
      return;
    }

    try {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (_) {
          print('Interstitial ad shown');
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Interstitial ad failed to show: ${error.message}');
          ad.dispose();
          _isInterstitialLoaded = false;
          // Preload next ad
          loadInterstitialAd();
        },
        onAdDismissedFullScreenContent: (ad) {
          print('Interstitial ad dismissed');
          ad.dispose();
          _isInterstitialLoaded = false;
          // Preload next ad for next match
          loadInterstitialAd();
        },
      );

      await _interstitialAd!.show();
    } catch (e) {
      print('Error showing interstitial ad: $e');
    }
  }

  // Preload interstitial ad (called during gameplay)
  void preloadInterstitialAd() {
    if (!_isInterstitialLoaded) {
      loadInterstitialAd();
    }
  }

  // Dispose ads
  Future<void> dispose() async {
    try {
      if (_isBannerLoaded) {
        await _bannerAd.dispose();
      }
      if (_isInterstitialLoaded && _interstitialAd != null) {
        await _interstitialAd!.dispose();
      }
    } catch (e) {
      print('Error disposing ads: $e');
    }
  }

  bool get isBannerLoaded => _isBannerLoaded;
  bool get isInterstitialLoaded => _isInterstitialLoaded;
}
