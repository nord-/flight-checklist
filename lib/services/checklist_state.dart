import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistState extends ChangeNotifier {
  static const _prefsKey = 'checkedItems';
  final Set<String> _checked = {};
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_prefsKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _checked.addAll(decoded.cast<String>());
    }
  }

  bool isChecked(String checklistId, String pageId, String itemId) {
    return _checked.contains(_key(checklistId, pageId, itemId));
  }

  void toggle(String checklistId, String pageId, String itemId) {
    final k = _key(checklistId, pageId, itemId);
    if (!_checked.remove(k)) _checked.add(k);
    _persist();
    notifyListeners();
  }

  void resetPage(String checklistId, String pageId) {
    final prefix = '$checklistId:$pageId:';
    _checked.removeWhere((k) => k.startsWith(prefix));
    _persist();
    notifyListeners();
  }

  void resetAll(String checklistId) {
    final prefix = '$checklistId:';
    _checked.removeWhere((k) => k.startsWith(prefix));
    _persist();
    notifyListeners();
  }

  String _key(String c, String p, String i) => '$c:$p:$i';

  void _persist() {
    _prefs?.setString(_prefsKey, jsonEncode(_checked.toList()));
  }
}
