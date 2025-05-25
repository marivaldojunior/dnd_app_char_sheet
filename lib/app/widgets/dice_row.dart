import 'package:flutter/material.dart';
import 'package:dnd_app_char_sheet/app/data/diceset.dart';
import 'package:provider/provider.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';
import 'dice_roll.dart'; // Assuming this is the correct path

class DiceRow extends StatefulWidget {
  const DiceRow({super.key});

  @override
  _DiceRowState createState() => _DiceRowState();
}

class _DiceRowState extends State<DiceRow> {
  Map<String, int> diceCount = {
    'D4': 0,
    'D6': 0,
    'D8': 0,
    'D10': 0,
    'D12': 0,
    'D20': 0,
  };

  void _incrementDice(String diceType) {
    setState(() {
      diceCount[diceType] = (diceCount[diceType] ?? 0) + 1;
    });
  }

  void _resetDice() {
    setState(() {
      diceCount.updateAll((key, value) => 0);
    });
  }

  void _rollDice(BuildContext context) {
    List<int> dices = [
      diceCount['D4']!,
      diceCount['D6']!,
      diceCount['D8']!,
      diceCount['D10']!,
      diceCount['D12']!,
      diceCount['D20']!,
    ];

    if (dices.any((count) => count > 0)) {
      DiceSet tempDiceSet = DiceSet(
        name: 'Quick Roll', // Traduzido: '快速投掷' para 'Quick Roll'
        dices: dices,
        modifier: 0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DiceRollPopup(diceSet: tempDiceSet);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one die to roll')), // Traduzido: '请至少选择一个骰子进行投掷' para 'Please select at least one die to roll'
      );
    }
  }

  void _saveDiceSet(BuildContext context) {
    List<int> dices = [
      diceCount['D4']!,
      diceCount['D6']!,
      diceCount['D8']!,
      diceCount['D10']!,
      diceCount['D12']!,
      diceCount['D20']!,
    ];

    if (dices.every((count) => count == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one die')), // Traduzido: '请至少选择一个骰子' para 'Please select at least one die'
      );
      return;
    }

    String diceSetName = '';
    int modifier = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Dice Set'), // Traduzido: '保存骰子组' para 'Save Dice Set'
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Dice Set Name'), // Traduzido: '骰子组名称' para 'Dice Set Name'
                onChanged: (value) {
                  diceSetName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Modifier'), // Traduzido: '调整值' para 'Modifier'
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  modifier = int.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'), // Traduzido: '保存' para 'Save'
              onPressed: () {
                if (diceSetName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a dice set name')), // Traduzido: '请输入骰子组名称' para 'Please enter a dice set name'
                  );
                  return;
                }

                DiceSet newDiceSet = DiceSet(
                  name: diceSetName,
                  dices: dices,
                  modifier: modifier,
                );

                Provider.of<CharacterManager>(context, listen: false)
                    .addDiceSet(newDiceSet);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDiceButton('D4'),
            _buildDiceButton('D6'),
            _buildDiceButton('D8'),
            _buildDiceButton('D10'),
            _buildDiceButton('D12'),
            _buildDiceButton('D20'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'), // Traduzido: '重置' para 'Reset'
              onPressed: _resetDice,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.casino),
              label: const Text('Roll'), // Traduzido: '投掷' para 'Roll'
              onPressed: () => _rollDice(context),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'), // Traduzido: '保存' para 'Save'
              onPressed: () => _saveDiceSet(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiceButton(String diceType) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _incrementDice(diceType),
          child: Card(
            color: diceCount[diceType]! > 0
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                diceType,
                style: TextStyle(
                  color: diceCount[diceType]! > 0
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : null,
                ),
              ),
            ),
          ),
        ),
        if (diceCount[diceType]! > 0) // Only show if count is greater than 0
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${diceCount[diceType]}', // Show current count
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}