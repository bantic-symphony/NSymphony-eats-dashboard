/// Centralized application constants for strings, configuration, and UI values.
abstract final class AppConstants {
  // App Info
  static const String appTitle = 'Symphony Eats Dashboard';
  static const String appBarTitle = 'NSymphony Eats - Weekly Menu';

  // Date/Time Formats
  static const String dateFormatMonthDay = 'MMM d';
  static const String dateFormatFull = 'MMMM d, yyyy';
  static const String timeFormat24h = 'HH:mm';

  // Timezone
  static const int noviSadWinterOffset = 1; // CET (UTC+1)
  static const int noviSadSummerOffset = 2; // CEST (UTC+2)

  // Timer Intervals
  static const int clockUpdateIntervalSeconds = 1;

  // Animation Durations (milliseconds)
  static const int animationBaseDuration = 600;
  static const int animationStaggerDelay = 100;

  // Animation Values
  static const double animationSlideOffset = 50.0;

  // Decorative Background Animation Durations (seconds)
  static const int bgRotation1Duration = 80;
  static const int bgRotation2Duration = 70;
  static const int bgRotation3Duration = 100;
  static const int bgRotation4Duration = 75;
  static const int bgRotation5Duration = 90;
  static const int bgMovement1Duration = 50;
  static const int bgMovement2Duration = 60;
  static const int bgMovement3Duration = 55;
  static const int bgMovement4Duration = 65;
  static const int bgMovement5Duration = 70;

  // Decorative Background Positions & Offsets
  static const double bgShape1Top = 40.0;
  static const double bgShape1Left = 50.0;
  static const double bgShape1OffsetX = 40.0;
  static const double bgShape1OffsetY = 50.0;

  static const double bgShape2Top = 60.0;
  static const double bgShape2Right = 100.0;
  static const double bgShape2OffsetX = 30.0;
  static const double bgShape2OffsetY = 60.0;

  static const double bgShape3Bottom = 80.0;
  static const double bgShape3Left = 60.0;
  static const double bgShape3OffsetX = 70.0;
  static const double bgShape3OffsetY = 40.0;

  static const double bgShape4Bottom = 60.0;
  static const double bgShape4Right = 80.0;
  static const double bgShape4OffsetX = 50.0;
  static const double bgShape4OffsetY = 50.0;

  static const double bgShape5TopFactor = 0.4;
  static const double bgShape5LeftFactor = 0.25;
  static const double bgShape5OffsetX = 60.0;
  static const double bgShape5OffsetY = 80.0;

  // Decorative Background Sizes
  static const double bgShape1Size = 150.0;
  static const double bgShape2Size = 180.0;
  static const double bgShape3Size = 200.0;
  static const double bgShape4Size = 250.0;
  static const double bgShape5Size = 220.0;

  // Decorative Background Opacities
  static const double bgShape1Opacity = 0.15;
  static const double bgShape2Opacity = 0.12;
  static const double bgShape3Opacity = 0.10;
  static const double bgShape4Opacity = 0.13;
  static const double bgShape5Opacity = 0.08;

  // Asset Paths
  static const String shapeYellowStripes = 'assets/images/shapes/shape_yellow_stripes.png';
  static const String shapePurpleCircles = 'assets/images/shapes/shape_purple_circles.png';
  static const String shapeCoralCurves = 'assets/images/shapes/shape_coral_curves.png';
  static const String shapeYellowCurves = 'assets/images/shapes/shape_yellow_curves.png';
  static const String shapeCoralSemicircle = 'assets/images/shapes/shape_coral_semicircle.png';

  // AppBar
  static const double appBarElevation = 4.0;
  static const double appBarToolbarHeight = 80.0;
  static const double appBarIconSize = 36.0;
  static const double appBarTitleFontSize = 28.0;
  static const double appBarClockPaddingRight = 24.0;

  // Clock
  static const double clockFontSize = 48.0;
  static const double clockLetterSpacing = 2.0;

  // Card Styling
  static const double cardBorderRadius = 20.0;
  static const double cardBorderWidthToday = 2.5;
  static const double cardBorderWidthNormal = 1.5;
  static const double cardTodayShadowBlur = 40.0;
  static const double cardTodayShadowSpread = 4.0;
  static const double cardTodayShadowOffsetY = 4.0;
  static const double cardNormalShadowBlur = 10.0;
  static const double cardNormalShadowOffsetY = 3.0;

  // Opacity Values
  static const double opacityCardToday = 1.0;
  static const double opacityCardNormal = 0.75;
  static const double opacityTodayShadow = 0.40;
  static const double opacityBlackShadow = 0.08;
  static const double opacityBlackShadowLight = 0.04;
  static const double opacityTodayBorder = 0.45;
  static const double opacityDivider = 0.2;
  static const double opacityChipLabel = 0.8;
  static const double opacityWhiteOverlay = 0.5;
  static const double opacityWhiteOverlayStrong = 0.95;
  static const double opacityErrorBg = 0.1;
  static const double opacityStatBorder = 0.3;
  static const double opacityStatShadow = 0.1;

  // Layout - Chips Area
  static const double chipsAreaHeight = 130.0;

  // Font Sizes
  static const double fontSizeWeekdayToday = 48.0;
  static const double fontSizeWeekdayNormal = 32.0;
  static const double fontSizeDateToday = 34.0;
  static const double fontSizeDateNormal = 26.0;
  static const double fontSizeMealLabelToday = 30.0;
  static const double fontSizeMealLabelNormal = 24.0;
  static const double fontSizeMealItemToday = 28.0;
  static const double fontSizeMealItemNormal = 22.0;
  static const double fontSizeChipCount = 48.0;
  static const double fontSizeChipLabel = 11.0;
  static const double fontSizeStatCount = 36.0;
  static const double fontSizeNote = 20.0;
  static const double fontSizeEmptyStateMessage = 24.0;
  static const double fontSizeErrorTitle = 18.0;
  static const double fontSizeErrorMessage = 14.0;
  static const double fontSizeRetryButton = 16.0;
  static const double fontSizeToday = 16.0;
  static const double fontSizeDateLabel = 13.0;
  static const double fontSizeTime = 12.0;

  // Icon Sizes
  static const double iconSizeMealToday = 34.0;
  static const double iconSizeMealNormal = 28.0;
  static const double iconSizeEmptyState = 96.0;
  static const double iconSizeClosedNote = 48.0;
  static const double iconSizeError = 40.0;
  static const double iconSizeRefresh = 20.0;
  static const double iconSizeStat = 22.0;

  // Divider
  static const double dividerHeight = 2.0;

  // Border Width
  static const double statCardBorderWidth = 1.5;
  static const double statCardShadowBlur = 6.0;
  static const double statCardShadowOffsetY = 2.0;

  // Line Height
  static const double lineHeightMealItem = 1.5;
  static const double lineHeightNote = 1.4;

  // Letter Spacing
  static const double letterSpacingWeekday = 0.8;
  static const double letterSpacingStatLabel = 0.6;
  static const double letterSpacingChipLabel = 0.8;

  // Loading Indicator
  static const double loadingStrokeWidth = 4.0;
  static const double loadingStrokeWidthThin = 3.0;

  // Text Strings
  static const String labelRegular = 'Regular';
  static const String labelVegetarian = 'Vegetarian';
  static const String labelNoPreference = 'No Pref.';
  static const String labelToday = 'Today';
  static const String labelRetry = 'Retry';
  static const String errorLoadingData = 'Error Loading Data';
  static const String noMenuAvailable = 'No menu available';

  // Day Count (for animations)
  static const int weekdayCount = 5;

  // DST Transition Hour (UTC)
  static const int dstTransitionHourUtc = 1;
}
