class Checklist {
  final String id;
  final String title;
  final String? aircraft;
  final String? note;
  final bool emergency;
  final List<ChecklistPage> pages;

  Checklist({
    required this.id,
    required this.title,
    this.aircraft,
    this.note,
    this.emergency = false,
    required this.pages,
  });

  factory Checklist.fromJson(Map<String, dynamic> j) => Checklist(
        id: j['id'] as String,
        title: j['title'] as String,
        aircraft: j['aircraft'] as String?,
        note: j['note'] as String?,
        emergency: (j['emergency'] as bool?) ?? false,
        pages: (j['pages'] as List)
            .map((p) => ChecklistPage.fromJson(p as Map<String, dynamic>))
            .toList(),
      );
}

class ChecklistPage {
  final String id;
  final String title;
  final List<Chapter> chapters;

  ChecklistPage({
    required this.id,
    required this.title,
    required this.chapters,
  });

  factory ChecklistPage.fromJson(Map<String, dynamic> j) => ChecklistPage(
        id: j['id'] as String,
        title: j['title'] as String,
        chapters: (j['chapters'] as List)
            .map((c) => Chapter.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}

class Chapter {
  final String title;
  final List<ChecklistItem> items;

  Chapter({required this.title, required this.items});

  factory Chapter.fromJson(Map<String, dynamic> j) => Chapter(
        title: j['title'] as String,
        items: (j['items'] as List)
            .map((i) => ChecklistItem.fromJson(i as Map<String, dynamic>))
            .toList(),
      );
}

class ChecklistItem {
  final String id;
  final String label;
  final String? value;

  ChecklistItem({required this.id, required this.label, this.value});

  factory ChecklistItem.fromJson(Map<String, dynamic> j) => ChecklistItem(
        id: j['id'] as String,
        label: j['label'] as String,
        value: j['value'] as String?,
      );
}
