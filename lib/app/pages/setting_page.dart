import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // '设置' está traduzido para 'Settings'
      ),
      body: const Center(
        child: Text('More settings will be added in the future'), // '未来会添加更多设置' está traduzido para 'More settings will be added in the future'
      ),
    );
  }
}