import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

final configProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final contents = await rootBundle.loadString('assets/data/config.json');
  return json.decode(contents);
});

final apiUrlProvider = Provider<String?>((ref) {
  final config = ref.watch(configProvider).asData?.value;
  return config?['apiUrl'];
}); 