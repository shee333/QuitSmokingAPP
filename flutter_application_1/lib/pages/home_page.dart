import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/quit_state.dart';
import 'log_page.dart';
import 'stats_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  final List<Widget> _pages = const [
    LogPage(),
    StatsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<QuitState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('戒烟助手'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '今日: ${state.todayCount}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
      body: _pages[_tabIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: '记录'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), label: '统计'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: '设置'),
        ],
      ),
    );
  }
}


