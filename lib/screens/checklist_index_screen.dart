import 'package:flutter/material.dart';
import '../models/checklist.dart';
import '../services/checklist_state.dart';
import 'page_screen.dart';

class ChecklistIndexScreen extends StatelessWidget {
  final ChecklistState state;
  final Checklist checklist;

  const ChecklistIndexScreen({
    super.key,
    required this.state,
    required this.checklist,
  });

  @override
  Widget build(BuildContext context) {
    final emergency = checklist.emergency;
    return Scaffold(
      appBar: AppBar(
        title: Text(checklist.title),
        backgroundColor: emergency ? Colors.red.shade700 : null,
        foregroundColor: emergency ? Colors.white : null,
        iconTheme:
            emergency ? const IconThemeData(color: Colors.white) : null,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (v) {
              if (v == 'reset_all') _confirmResetAll(context);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'reset_all',
                child: Text('Nollställ allt'),
              ),
            ],
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) => ListView.separated(
          itemCount: checklist.pages.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final page = checklist.pages[i];
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text(
                page.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: _pageStatusIcon(page),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PageScreen(
                    state: state,
                    checklist: checklist,
                    pageIndex: i,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _pageStatusIcon(ChecklistPage page) {
    var total = 0;
    var done = 0;
    for (final ch in page.chapters) {
      for (final it in ch.items) {
        total++;
        if (state.isChecked(checklist.id, page.id, it.id)) done++;
      }
    }
    if (total == 0 || done == 0) {
      return const Icon(Icons.chevron_right, size: 32);
    }
    if (done == total) {
      return Icon(Icons.check_circle, size: 32, color: Colors.green.shade600);
    }
    return Icon(
      Icons.check_circle_outline,
      size: 32,
      color: Colors.amber.shade700,
    );
  }

  Future<void> _confirmResetAll(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nollställ allt?'),
        content:
            Text('Nollställ alla bockar för ${checklist.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Nollställ'),
          ),
        ],
      ),
    );
    if (ok == true) state.resetAll(checklist.id);
  }
}
