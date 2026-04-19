import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/checklist.dart';

class ChecklistLoader {
  static const _files = ['pa28.json', 'pa28_emergency.json'];

  static Future<List<Checklist>> loadAll() async {
    final out = <Checklist>[];
    for (final name in _files) {
      final raw = await rootBundle.loadString('assets/checklists/$name');
      out.add(Checklist.fromJson(jsonDecode(raw) as Map<String, dynamic>));
    }
    return out;
  }
}
