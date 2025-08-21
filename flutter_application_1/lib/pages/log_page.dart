import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/quit_state.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<QuitState>();
    final entries = state.entries.reversed.toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    final note = await showDialog<String?>(
                      context: context,
                      builder: (ctx) => const _NoteDialog(),
                    );
                    if (note != null) {
                      await context.read<QuitState>().addEntry(note: note);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('记录一次吸烟'),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final e = entries[i];
              return ListTile(
                leading: const Icon(Icons.smoke_free),
                title: Text(TimeOfDay.fromDateTime(e.dateTime).format(context)),
                subtitle: e.note == null || e.note!.isEmpty ? null : Text(e.note!),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NoteDialog extends StatefulWidget {
  const _NoteDialog();

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('可选：添加备注'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: '例如：饭后/压力大/社交场合'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('跳过')),
        FilledButton(onPressed: () => Navigator.pop(context, _controller.text.trim()), child: const Text('确定')),
      ],
    );
  }
}


