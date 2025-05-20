import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/consumable_widget.dart';

class WidgetTestPage extends StatelessWidget { // "WidgetTestPage" já é um nome em inglês
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Test'), // Traduzido: 'Widget测试' para 'Widget Test'
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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