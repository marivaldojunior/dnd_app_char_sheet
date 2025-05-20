import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatelessWidget {
  final String githubUrl = 'https://github.com/wanakiki/dnd_character_sheet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'), // Traduzido: '关于' para 'About'
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feature Introduction', // Traduzido: '功能介绍' para 'Feature Introduction'
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text( // Traduzido
                'The initial purpose of this app was to avoid frequent modifications to character sheets during gameplay and to facilitate money calculation and quick spell lookup. '
                    'It now supports custom dice and a spellbook feature. Future updates may include data for magic items, feats, etc. '
                    'The current version supports character import and export. '
                    'The design principle of the app is to minimize permission requests to ensure software reliability.'),
            const SizedBox(height: 16),
            const Text(
              'Project Address', // Traduzido: '项目地址' para 'Project Address'
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is an open-source project. Project address:', // Traduzido: '这是一个开源的项目，项目地址：' para 'This is an open-source project. Project address:'
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: githubUrl));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')), // Traduzido: '链接已复制到剪贴板' para 'Link copied to clipboard'
                );
              },
              child: Text(
                githubUrl,
                style: const TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Data Source', // Traduzido: '数据来源' para 'Data Source'
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text( // Traduzido
              'The spell data in the app comes from the Excel semi-automatic character sheet tool, authors: Tai Yi, Bear Mama 2D6.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Finally', // Traduzido: '最后' para 'Finally'
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text( // Traduzido
              'For me, role-playing is the best practice of the phrase "If you have an idea, go for it."',
            ),
          ],
        ),
      ),
    );
  }
}