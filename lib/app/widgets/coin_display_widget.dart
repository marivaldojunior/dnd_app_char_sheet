import 'package:flutter/material.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';
import 'package:provider/provider.dart';

class CoinDisplayWidget extends StatelessWidget {
  final List<int> coin; // [gold, silver, copper]

  const CoinDisplayWidget({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () => _showEditDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.monetization_on,
                      color: Color.fromARGB(255, 187, 179, 17)),
                  const SizedBox(width: 8),
                  Text('Gold: ${coin[0]}'), // Traduzido: '金币' para 'Gold'
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Silver: ${coin[1]}'), // Traduzido: '银币' para 'Silver'
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.monetization_on,
                      color: Color.fromARGB(160, 121, 85, 72)),
                  const SizedBox(width: 8),
                  Text('Copper: ${coin[2]}'), // Traduzido: '铜币' para 'Copper'
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    int goldInput = 0;
    int silverInput = 0;
    int copperInput = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modify Coins'), // Traduzido: '修改金币' para 'Modify Coins'
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                context,
                'Gold', // Traduzido: '金币' para 'Gold'
                goldInput,
                    (value) => goldInput = _parseInput(value),
              ),
              _buildTextField(
                context,
                'Silver', // Traduzido: '银币' para 'Silver'
                silverInput,
                    (value) => silverInput = _parseInput(value),
              ),
              _buildTextField(
                context,
                'Copper', // Traduzido: '铜币' para 'Copper'
                copperInput,
                    (value) => copperInput = _parseInput(value),
              ),
              const SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _applyTransaction(
                      goldInput, silverInput, copperInput, context);
                  Navigator.of(context).pop();
                },
                child: const Text("Gain")), // Traduzido: "获得" para "Gain"
            TextButton(
                onPressed: () {
                  _applyLoss(goldInput, silverInput, copperInput, context);
                  Navigator.of(context).pop();
                },
                child: const Text("Lose")), // Traduzido: "失去" para "Lose"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
            )
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      BuildContext context,
      String label,
      int initialValue,
      Function(String) onChanged,
      ) {
    final TextEditingController controller =
    TextEditingController(text: initialValue.toString());

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  int _parseInput(String value) {
    return int.tryParse(value) ?? 0;
  }

  void _applyTransaction(
      int goldInput, int silverInput, int copperInput, BuildContext context) {
    if (_validateInput(goldInput, silverInput, copperInput)) {
      int totalCopper = coin[0] * 10000 + coin[1] * 100 + coin[2];
      int newCopper =
          totalCopper + goldInput * 10000 + silverInput * 100 + copperInput;

      List<int> newCoin = [
        newCopper ~/ 10000,
        (newCopper % 10000) ~/ 100,
        newCopper % 100,
      ];

      CharacterManager characterManager =
      Provider.of<CharacterManager>(context, listen: false);
      characterManager.updateCharacter({"coin": newCoin});
    } else {
      // TODO show the error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Input Error'), // Traduzido: '输入错误' para 'Input Error'
            content: const Text('Please enter valid numbers.'), // Traduzido: '请输入有效的数字。' para 'Please enter valid numbers.'
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'), // Traduzido: '确定' para 'OK'
              ),
            ],
          );
        },
      );
    }
  }

  void _applyLoss(
      int goldInput, int silverInput, int copperInput, BuildContext context) {
    if (_validateInput(goldInput, silverInput, copperInput)) {
      int totalCopper = coin[0] * 10000 + coin[1] * 100 + coin[2];
      int newCopper =
          totalCopper - (goldInput * 10000 + silverInput * 100 + copperInput);

      if (newCopper < 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Insufficient Funds'), // Traduzido: '金钱不足' para 'Insufficient Funds'
              content: const Text( // Traduzido: '您的金币、银币或铜币不足以进行此操作。'
                  'You do not have enough gold, silver, or copper for this transaction.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'), // Traduzido: '确定' para 'OK'
                ),
              ],
            );
          },
        );
      } else {
        List<int> newCoin = [
          newCopper ~/ 10000,
          (newCopper % 10000) ~/ 100,
          newCopper % 100,
        ];

        CharacterManager characterManager =
        Provider.of<CharacterManager>(context, listen: false);
        characterManager.updateCharacter({"coin": newCoin});
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Input Error'), // Traduzido: '输入错误' para 'Input Error'
            content: const Text('Please enter valid numbers.'), // Traduzido: '请输入有效的数字。' para 'Please enter valid numbers.'
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'), // Traduzido: '确定' para 'OK'
              ),
            ],
          );
        },
      );
    }
  }

  bool _validateInput(int goldInput, int silverInput, int copperInput) {
    // Check if the inputs are not negative and at least one of them is not zero
    return goldInput >= 0 &&
        silverInput >= 0 &&
        copperInput >= 0 &&
        (goldInput > 0 || silverInput > 0 || copperInput > 0);
  }
}