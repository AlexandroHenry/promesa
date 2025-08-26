import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Helper class for working with SVG assets
class SvgAssetHelper {
  SvgAssetHelper._();

  /// Get SVG widget with error handling
  static Widget getSvg(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    Widget? errorWidget,
  }) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      colorFilter: color != null 
          ? ColorFilter.mode(color, colorBlendMode)
          : null,
      semanticsLabel: semanticsLabel,
      placeholderBuilder: (context) {
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

  /// Get SVG icon (square aspect ratio)
  static Widget getSvgIcon(
    String assetPath, {
    double size = 24.0,
    Color? color,
    String? semanticsLabel,
  }) {
    return getSvg(
      assetPath,
      width: size,
      height: size,
      color: color,
      semanticsLabel: semanticsLabel,
    );
  }

  /// Get tinted SVG (with color overlay)
  static Widget getTintedSvg(
    String assetPath,
    Color color, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    BlendMode blendMode = BlendMode.srcIn,
  }) {
    return getSvg(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: blendMode,
    );
  }
}

/// Extension on String for easy SVG access
extension SvgStringExtension on String {
  /// Convert string to SVG widget
  Widget toSvg({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    String? semanticsLabel,
  }) {
    return SvgAssetHelper.getSvg(
      this,
      width: width,
      height: height,
      fit: fit,
      color: color,
      semanticsLabel: semanticsLabel,
    );
  }

  /// Convert string to SVG icon
  Widget toSvgIcon({
    double size = 24.0,
    Color? color,
    String? semanticsLabel,
  }) {
    return SvgAssetHelper.getSvgIcon(
      this,
      size: size,
      color: color,
      semanticsLabel: semanticsLabel,
    );
  }

  /// Convert string to tinted SVG
  Widget toTintedSvg(
    Color color, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    BlendMode blendMode = BlendMode.srcIn,
  }) {
    return SvgAssetHelper.getTintedSvg(
      this,
      color,
      width: width,
      height: height,
      fit: fit,
      blendMode: blendMode,
    );
  }
}