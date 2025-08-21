import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/quit_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _goalController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final state = context.read<QuitState>();
    if (state.dailyGoal > 0) {
      _goalController.text = state.dailyGoal.toString();
    }
    _selectedDate = state.quitStart;
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<QuitState>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('基础设置', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('每日目标(次)：'),
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _goalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '例如 5'),
                onSubmitted: (_) => _saveGoal(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(onPressed: _saveGoal, child: const Text('保存')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('开始日期：'),
            const SizedBox(width: 8),
            Text(_selectedDate == null ? '未设置' : _selectedDate!.toString().split(' ').first),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? now,
                  firstDate: DateTime(now.year - 5),
                  lastDate: DateTime(now.year + 1),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                  await context.read<QuitState>().setQuitStart(picked);
                }
              },
              child: const Text('选择日期'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('说明', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          '点击“记录一次吸烟”快速记录一次事件；在统计页查看近7天趋势，' 
          '可在设置里设定每日目标与开始戒烟日期。',
        ),
        const SizedBox(height: 40),
        Center(
          child: Text(
            '当前已记录：${state.entries.length} 次',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> _saveGoal() async {
    final text = _goalController.text.trim();
    final goal = int.tryParse(text) ?? 0;
    await context.read<QuitState>().setDailyGoal(goal);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已保存目标')));
  }
}


