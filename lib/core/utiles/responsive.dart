class ResponsiveUtils {
  final double screenWidth;

  ResponsiveUtils(this.screenWidth);

  bool get isSmallDevice => screenWidth < 600;

  bool get isBigDevice => screenWidth >= 600;

  static double calculateResponsiveWidth(double screenWidth, double ratio) {
    return screenWidth * ratio;
  }

  static double calculateResponsiveHeight(double screenHeight, double ratio) {
    return screenHeight * ratio;
  }

  static double calculateResponsiveFontSize(double screenHeight, double ratio) {
    return screenHeight * ratio;
  }

  static double calculateResponsivePadding(double baseWidth, double ratio) {
    return baseWidth * ratio;
  }
}