import 'package:flutter/material.dart';
import '../widgets/consumable_widget.dart';

class WidgetTestPage extends StatelessWidget {
  const WidgetTestPage({super.key});
 // "WidgetTestPage" já é um nome em inglês
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Test'), // Traduzido: 'Widget测试' para 'Widget Test'
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConsumableWidget(),
          ],
        ),
      ),
    );
  }
}