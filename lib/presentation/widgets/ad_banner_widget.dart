import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdaptiveBannerAd extends StatelessWidget {
  final AdSize adSize;

  const AdaptiveBannerAd({Key? key, required this.adSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      color: Colors.black87,
    );
  }
}
