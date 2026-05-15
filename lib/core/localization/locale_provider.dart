import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// Current locale ko manage karne wala provider
final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en'); // Default Language
});
