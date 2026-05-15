import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../../shared/services/data/app_data_keys.dart';

import '../../shared/session/session_events.dart';
import '../../shared/utils/app_snackbar.dart';

import '../constants/constants.dart';

part 'api_call.dart';
part 'api_endpoints.dart';
part 'api_response.dart';

// part './rent/rent_api_service.dart';
part './device/devices_api_service.dart';

part './interceptor/bearer_api_interceptor.dart';
