part of 'app_extensions.dart';

/// Extension on `num` to simplify spacing with SizedBox
extension SpacingExtension on num {
  /// Horizontal space — returns a [SizedBox] with width equal to this number
  ///
  /// Example: `16.horizontalSpace` → `SizedBox(width: 16)`
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// Vertical space — returns a [SizedBox] with height equal to this number
  ///
  /// Example: `8.verticalSpace` → `SizedBox(height: 8)`
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Both horizontal and vertical space — useful for square spacing
  ///
  /// Example: `10.space` → `SizedBox(width: 10, height: 10)`
  SizedBox get space => SizedBox(width: toDouble(), height: toDouble());
}
