import 'package:flutter/material.dart';
import '../models/checklist.dart';
import '../services/checklist_state.dart';
import 'checklist_index_screen.dart';

class HomeScreen extends StatelessWidget {
  final ChecklistState state;
  final List<Checklist> checklists;

  const HomeScreen({
    super.key,
    required this.state,
    required this.checklists,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...checklists]
      ..sort((a, b) => (a.emergency ? 1 : 0) - (b.emergency ? 1 : 0));
    return Scaffold(
      appBar: AppBar(title: const Text('Flygchecklistor')),
      body: ListView.separated(
        itemCount: sorted.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = sorted[i];
          final color = c.emergency ? Colors.red.shade700 : null;
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            title: Text(
              c.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: color),
            ),
            subtitle: c.aircraft != null
                ? Text(c.aircraft!, style: TextStyle(color: color))
                : null,
            trailing: Icon(Icons.chevron_right, size: 32, color: color),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    ChecklistIndexScreen(state: state, checklist: c),
              ),
            ),
          );
        },
      ),
    );
  }
}
