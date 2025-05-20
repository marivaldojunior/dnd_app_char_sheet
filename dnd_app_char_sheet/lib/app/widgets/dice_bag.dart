import 'package:flutter/material.dart';
import '../data/character_manager.dart';
import '../data/diceset.dart';
import 'dice_roll.dart'; // Assuming this is the correct path for DiceRollPopup
import 'package:provider/provider.dart';

class DiceBagWidget extends StatelessWidget {
  final List<DiceSet> diceBag;

  const DiceBagWidget({
    Key? key,
    required this.diceBag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Remove divider line color
        ),
        child: ExpansionTile(
          title: Text(
            'Dice Bag', // Traduzido: '骰子袋' para 'Dice Bag'
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          initiallyExpanded: true,
          children: [
            ...diceBag.map((diceSet) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(diceSet.name,
                      style: Theme.of(context).textTheme.bodySmall),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.casino),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DiceRollPopup(diceSet: diceSet);
                            },
                          );
                        },
                        tooltip: 'Roll Dice', // Traduzido: '掷骰子' para 'Roll Dice'
                      ),
                      IconButton(
                        icon: Stack(
                          children: [
                            const Icon(Icons.casino),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color:
                                  Theme.of(context).colorScheme.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.casino, size: 12),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DiceRollPopup(
                                diceSet: diceSet,
                                advantageDisadvantage: true,
                              );
                            },
                          );
                        },
                        tooltip: 'Roll with Advantage/Disadvantage', // Traduzido: '优势/劣势掷骰子' para 'Roll with Advantage/Disadvantage'
                      ),
                    ],
                  ),
                  onLongPress: () {
                    _showEditDialog(context, diceSet);
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Dice Set'), // Traduzido: '添加骰子组' para 'Add Dice Set'
                onPressed: () {
                  _addDiceSet(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, DiceSet diceSet) {
    // Initialize dice counts
    List<int> dices = List.from(diceSet.dices); // Make a mutable copy
    int d4Count = dices[0];
    int d6Count = dices[1];
    int d8Count = dices[2];
    int d10Count = dices[3];
    int d12Count = dices[4];
    int d20Count = dices[5];

    // Initialize dice set name
    String diceSetName = diceSet.name;

    // Initialize modifier
    int modifier = diceSet.modifier;

    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          title: Text('Edit Dice Set: $diceSetName'), // Traduzido: '修改骰子组' para 'Edit Dice Set'
    content: SingleChildScrollView(
    child: StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
    return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    // Input for dice set name
    TextField(
    decoration: InputDecoration(labelText: 'New Dice Set Name'), // Traduzido: '新的骰子组名称' para 'New Dice Set Name'
    controller: TextEditingController(text: diceSetName),
    onChanged: (value) {
    // No need for setState here as diceSetName is updated directly
    diceSetName = value;
    },),
      // Input for dice counts
      _buildDiceCountRow('D4', d4Count, (value) {
        setState(() {
          d4Count = value;
        });
      }),
      _buildDiceCountRow('D6', d6Count, (value) {
        setState(() {
          d6Count = value;
        });
      }),
      _buildDiceCountRow('D8', d8Count, (value) {
        setState(() {
          d8Count = value;
        });
      }),
      _buildDiceCountRow('D10', d10Count, (value) {
        setState(() {
          d10Count = value;
        });
      }),
      _buildDiceCountRow('D12', d12Count, (value) {
        setState(() {
          d12Count = value;
        });
      }),
      _buildDiceCountRow('D20', d20Count, (value) {
        setState(() {
          d20Count = value;
        });
      }),
      // Input for modifier
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Modifier'), // Traduzido: '调整值' para 'Modifier'
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    modifier--;
                  });
                },
              ),
              Text('$modifier'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    modifier++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    ],
    );
    },
    ),
    ),
        actions: [
          TextButton(
            child: const Text('Apply Changes'), // Traduzido: '应用修改' para 'Apply Changes'
            onPressed: () {
              if (diceSetName.isEmpty) { // Corrected condition
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a valid name')), // Traduzido: '请输入有效的名称' para 'Please enter a valid name'
                );
                return;
              }
              CharacterManager characterManager =
              Provider.of<CharacterManager>(context, listen: false);

              // Delete the old dice set
              characterManager.deleteDiceSet(diceSet.name);
              // Create and add the updated dice set
              DiceSet updatedDiceSet = DiceSet(
                name: diceSetName,
                dices: [
                  d4Count,
                  d6Count,
                  d8Count,
                  d10Count,
                  d12Count,
                  d20Count
                ],
                modifier: modifier,
              );

              characterManager.addDiceSet(updatedDiceSet);

              Navigator.of(context).pop();
            },
          ),
          GestureDetector(
            onDoubleTap: () {
              // Confirm delete on double tap
              CharacterManager characterManager =
              Provider.of<CharacterManager>(context, listen: false);
              characterManager.deleteDiceSet(diceSet.name);
              Navigator.of(context).pop();
            },
            child: TextButton(
              child: const Text('Delete (Double Tap to Confirm)'), // Traduzido: '删除（双击确认）' para 'Delete (Double Tap to Confirm)'
              onPressed: () {
                // Prompt user to double tap to confirm delete
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please double tap to confirm deletion')), // Traduzido: '请双击确认删除' para 'Please double tap to confirm deletion'
                );
              },
            ),
          ),
        ],
      );
        },
    );
  }

  Widget _buildDiceCountRow(String label, int count, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => onChanged(count > 0 ? count - 1 : 0),
            ),
            Text('$count'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(count + 1),
            ),
          ],
        ),
      ],
    );
  }

  void _addDiceSet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String diceSetName = '';
        List<int> dices = List.filled(6, 0); // Initialize with zero dice
        int modifier = 0;

        return AlertDialog(
          title: const Text('Add New Dice Set'), // Traduzido: '添加新骰子组' para 'Add New Dice Set'
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Dice Set Name'), // Traduzido: '骰子组名称' para 'Dice Set Name'
                      onChanged: (value) {
                        // No need for setState here
                        diceSetName = value;
                      },
                    ),
                    _buildDiceCountRow('D4', dices[0], (value) {
                      setState(() {
                        dices[0] = value;
                      });
                    }),
                    _buildDiceCountRow('D6', dices[1], (value) {
                      setState(() {
                        dices[1] = value;
                      });
                    }),
                    _buildDiceCountRow('D8', dices[2], (value) {
                      setState(() {
                        dices[2] = value;
                      });
                    }),
                    _buildDiceCountRow('D10', dices[3], (value) {
                      setState(() {
                        dices[3] = value;
                      });
                    }),
                    _buildDiceCountRow('D12', dices[4], (value) {
                      setState(() {
                        dices[4] = value;
                      });
                    }),
                    _buildDiceCountRow('D20', dices[5], (value) {
                      setState(() {
                        dices[5] = value;
                      });
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Modifier'), // Traduzido: '调整值' para 'Modifier'
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  modifier--;
                                });
                              },
                            ),
                            Text('$modifier'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  modifier++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Add'), // Traduzido: '添加' para 'Add'
              onPressed: () {
                if (diceSetName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid name')), // Traduzido: '请输入有效的名称' para 'Please enter a valid name'
                  );
                  return;
                }

                CharacterManager characterManager =
                Provider.of<CharacterManager>(context, listen: false);

                DiceSet newDiceSet = DiceSet(
                  name: diceSetName,
                  dices: dices,
                  modifier: modifier,
                );

                characterManager.addDiceSet(newDiceSet);

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}