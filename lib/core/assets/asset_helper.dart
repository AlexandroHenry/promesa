import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

/// Helper class for working with assets
class AssetHelper {
  AssetHelper._();

  /// Load asset as string (useful for JSON files, etc.)
  static Future<String> loadString(String assetPath) {
    return rootBundle.loadString(assetPath);
  }

  /// Load asset as bytes
  static Future<ByteData> loadBytes(String assetPath) {
    return rootBundle.load(assetPath);
  }

  /// Check if asset exists
  static Future<bool> exists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get image widget with error handling
  static Widget getImage(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    String? semanticLabel,
    Widget? errorWidget,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.image_not_supported,
                color: Color(0xFFBBBBBB),
              ),
            );
      },
    );
  }

  /// Get circular image widget
  static Widget getCircularImage(
    String assetPath, {
    required double radius,
    Widget? errorWidget,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(assetPath),
      onBackgroundImageError: (exception, stackTrace) {
        // Handle error silently, fallback will be shown
      },
      child: errorWidget,
    );
  }

  /// Get network image with asset fallback
  static Widget getNetworkImageWithAssetFallback(
    String? networkUrl,
    String fallbackAssetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    if (networkUrl == null || networkUrl.isEmpty) {
      return getImage(
        fallbackAssetPath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      );
    }

    return Image.network(
      networkUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        return getImage(
          fallbackAssetPath,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
        );
      },
    );
  }
}

/// Extension on String for easy asset access
extension AssetStringExtension on String {
  /// Convert string to Image widget
  Widget toImage({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return AssetHelper.getImage(
      this,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }

  /// Convert string to circular Image widget
  Widget toCircularImage({required double radius}) {
    return AssetHelper.getCircularImage(this, radius: radius);
  }

  /// Load asset as string
  Future<String> loadAsString() {
    return AssetHelper.loadString(this);
  }

  /// Check if asset exists
  Future<bool> assetExists() {
    return AssetHelper.exists(this);
  }
}