import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';

class HealthBar extends StatelessWidget {
  final int currentHitPoints;
  final int maxHitPoints;
  final int temporaryHitPoints;

  HealthBar({
    required this.currentHitPoints,
    required this.maxHitPoints,
    required this.temporaryHitPoints,
  });

  @override
  Widget build(BuildContext context) {
    double totalHitPoints = currentHitPoints + temporaryHitPoints.toDouble();
    double healthPercentage = totalHitPoints / maxHitPoints;

    return GestureDetector(
      onTap: () => _showHealthDialog(context),
      child: Column(
        children: [
          Text(
            'HP: $currentHitPoints / $maxHitPoints' +
                (temporaryHitPoints > 0
                    ? ' (Temporary: $temporaryHitPoints)' // Traduzido
                    : ''),
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(height: 4.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: LinearProgressIndicator(
              value: healthPercentage,
              backgroundColor: Colors.red.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  void _showHealthDialog(BuildContext context) {
    int newHitPoints = currentHitPoints;
    int newMaxHitPoints = maxHitPoints;
    int newTemporaryHitPoints =
        temporaryHitPoints;
    TextEditingController maxHpController =
    TextEditingController(text: maxHitPoints.toString());
    TextEditingController tempHpController =
    TextEditingController(text: temporaryHitPoints.toString());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Adjust Health'), // Traduzido
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Current: $currentHitPoints / $maxHitPoints'), // Traduzido
                  TextField(
                    controller: maxHpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'New Max Health'), // Traduzido
                    onChanged: (value) {
                      setState(() {
                        newMaxHitPoints =
                            int.tryParse(value) ?? newMaxHitPoints;
                        newHitPoints = newMaxHitPoints;
                      });
                    },
                  ),
                  TextField(
                    controller: tempHpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Temporary Health'), // Traduzido
                    onChanged: (value) {
                      setState(() {
                        newTemporaryHitPoints =
                            int.tryParse(value) ?? newTemporaryHitPoints;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        'Adjustment: ${newHitPoints - currentHitPoints}', // Traduzido
                        style: TextStyle(
                          fontSize: 16.0,
                          color: newHitPoints > currentHitPoints
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Slider(
                        value: newHitPoints.toDouble(),
                        min: 0,
                        max: newMaxHitPoints.toDouble(),
                        divisions: newMaxHitPoints,
                        label: newHitPoints.toString(),
                        onChanged: (value) {
                          setState(() {
                            newHitPoints = value.toInt();
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'), // Traduzido
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(newHitPoints);

                    CharacterManager characterManager =
                    Provider.of<CharacterManager>(context, listen: false);
                    characterManager.updateCharacter({
                      'currentHitPoints': newHitPoints,
                      'maxHitPoints': newMaxHitPoints,
                      'temporaryHitPoints': newTemporaryHitPoints,
                    });
                  },
                  child: Text('Confirm'), // Traduzido
                ),
              ],
            );
          },
        );
      },
    );
  }
}