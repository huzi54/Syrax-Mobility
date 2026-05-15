import 'package:flutter/cupertino.dart' hide Widget;
import 'package:flutter/material.dart';

import '../shared/services/logger/app_logger.dart';

part 'app_navigation.dart';
part 'app_routes.dart';

extension RouteExtension on Widget {
  MaterialPageRoute<dynamic> asRoute() =>
      MaterialPageRoute(builder: (_) => this);
}
