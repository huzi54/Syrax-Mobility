
part of 'constants.dart';

/// Robust, folder-structured asset access with .image()/.svg() methods per asset.
class AppAssets {
  AppAssets._();

  static final icons = _Icons();
  static final images = _Images();
}

class _Icons {
  static const String _base = 'assets/icons/';

  // Example: AppAssets.icons.google.image() or .svg()
  final _Asset google = const _Asset('${_base}google.png');
  final _Asset file = const _Asset('${_base}file.png');
  final _Asset documentation = const _Asset('${_base}documentation.png');
  final _Asset video = const _Asset('${_base}video.png');
}

class _Images {
  static const String _base = 'assets/images/';

  // Example: AppAssets.images.fullinLogo.image() or .svg()
  final _Asset applogo = const _Asset('${_base}applogo.png');
  final _Asset qrcode = const _Asset('${_base}qrcode1.png');
}

/////////////////////////////////////////////////////////////////////////////

class _Asset {
  final String path;
  const _Asset(this.path);

  /// Returns an Image widget for this asset with robust parameter support.
  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      path,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  /// Returns an ImageProvider for this asset.
  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(path, bundle: bundle, package: package);
  }

  /// Returns an SvgPicture widget for this asset with robust parameter support.
  SvgPicture svg({
    Key? key,
    AssetBundle? bundle,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Animation<double>? opacity,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? package,
    bool matchTextDirection = false,
    WidgetBuilder? placeholderBuilder,
    bool allowDrawingOutsideViewBox = false,
    SvgTheme? theme,
    Clip clipBehavior = Clip.hardEdge,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    ColorFilter? colorFilter,
  }) {
    return SvgPicture.asset(
      path,
      key: key,
      bundle: bundle,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      colorFilter: (color != null
          ? ColorFilter.mode(color, colorBlendMode)
          : null),
      package: package,
      matchTextDirection: matchTextDirection,
      placeholderBuilder: placeholderBuilder,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      theme: theme,
      clipBehavior: clipBehavior,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
    );
  }

  /// Returns the asset path.
  String get assetName => path.split('/').last;

  /// Returns the asset path (alias for assetName).
  String get pathName => path;
}
