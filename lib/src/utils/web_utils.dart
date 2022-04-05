import 'package:flutter/foundation.dart';

const double kMaxWebContentWidth = 1264;

const double kDefaultDesktopWebContentWidth = 500;

const double kWidthTrashHoldForMobileLayout = 1100;

final kIsWebMobile = kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

final kUserMobileLayoutForWeb = !kIsWeb || kIsWebMobile;
