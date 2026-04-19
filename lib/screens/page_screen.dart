import 'package:flutter/material.dart';
import '../models/checklist.dart';
import '../services/checklist_state.dart';

class PageScreen extends StatelessWidget {
  final ChecklistState state;
  final Checklist checklist;
  final int pageIndex;

  const PageScreen({
    super.key,
    required this.state,
    required this.checklist,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final emergency = checklist.emergency;
    final page = checklist.pages[pageIndex];
    final isFirst = pageIndex == 0;
    final isLast = pageIndex >= checklist.pages.length - 1;
    final prevLabel =
        isFirst ? 'Index' : checklist.pages[pageIndex - 1].title;
    final nextLabel =
        isLast ? 'Index' : checklist.pages[pageIndex + 1].title;

    return Scaffold(
      appBar: AppBar(
        title: Text('${checklist.title} – ${page.title}'),
        backgroundColor: emergency ? Colors.red.shade700 : null,
        foregroundColor: emergency ? Colors.white : null,
        iconTheme:
            emergency ? const IconThemeData(color: Colors.white) : null,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (v) {
              if (v == 'reset_page') {
                state.resetPage(checklist.id, page.id);
              } else if (v == 'reset_all') {
                _confirmResetAll(context);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'reset_page',
                child: Text('Nollställ sidan'),
              ),
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
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            for (final chapter in page.chapters) ...[
              _ChapterHeader(title: chapter.title),
              for (final item in chapter.items)
                _ItemTile(
                  item: item,
                  checked:
                      state.isChecked(checklist.id, page.id, item.id),
                  onTap: () =>
                      state.toggle(checklist.id, page.id, item.id),
                ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _PageNav(
        prevLabel: prevLabel,
        nextLabel: nextLabel,
        emergency: emergency,
        onPrev: () {
          if (isFirst) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => PageScreen(
                  state: state,
                  checklist: checklist,
                  pageIndex: pageIndex - 1,
                ),
              ),
            );
          }
        },
        onNext: () {
          if (isLast) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => PageScreen(
                  state: state,
                  checklist: checklist,
                  pageIndex: pageIndex + 1,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _confirmResetAll(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nollställ allt?'),
        content: Text('Nollställ alla bockar för ${checklist.title}?'),
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

class _ChapterHeader extends StatelessWidget {
  final String title;
  const _ChapterHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: scheme.surfaceContainerHighest,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final ChecklistItem item;
  final bool checked;
  final VoidCallback onTap;

  const _ItemTile({
    required this.item,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: checked
          ? Colors.green.withValues(alpha: 0.35)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: scheme.outlineVariant),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (item.value != null) ...[
                const SizedBox(height: 4),
                Text(
                  item.value!,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PageNav extends StatelessWidget {
  final String prevLabel;
  final String nextLabel;
  final bool emergency;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _PageNav({
    required this.prevLabel,
    required this.nextLabel,
    required this.emergency,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bg = emergency
        ? Colors.red.shade700
        : Theme.of(context).colorScheme.primary;
    final fg = Colors.white;
    return SafeArea(
      top: false,
      child: Container(
        color: bg,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: _NavButton(
                icon: Icons.chevron_left,
                label: prevLabel,
                alignEnd: false,
                fg: fg,
                onPressed: onPrev,
              ),
            ),
            Container(width: 1, height: 40, color: fg.withValues(alpha: 0.3)),
            Expanded(
              child: _NavButton(
                icon: Icons.chevron_right,
                label: nextLabel,
                alignEnd: true,
                fg: fg,
                onPressed: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool alignEnd;
  final Color fg;
  final VoidCallback onPressed;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.alignEnd,
    required this.fg,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: fg,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
    final arrow = Icon(icon, color: fg, size: 32);
    return InkWell(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: alignEnd
              ? [Flexible(child: text), const SizedBox(width: 4), arrow]
              : [arrow, const SizedBox(width: 4), Flexible(child: text)],
        ),
      ),
    );
  }
}
