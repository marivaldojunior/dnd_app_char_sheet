import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';

class ExperienceBar extends StatelessWidget {
  final int currentExperience;
  final int currentLevel;

  const ExperienceBar({super.key, required this.currentExperience, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    final int nextLevelXP = _experienceForNextLevel(currentLevel);
    final double progress = currentExperience / nextLevelXP;
    final int proficiencyBonus = _proficiencyBonusForLevel(currentLevel);

    return InkWell(
      onTap: () => _showExperienceInputDialog(context),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 20.0,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 8),
          Text(
              'XP: $currentExperience / $nextLevelXP | LV: $currentLevel | +$proficiencyBonus'),
        ],
      ),
    );
  }

  int _experienceForNextLevel(int level) {
    const List<int> xpThresholds = [
      300,
      900,
      2700,
      6500,
      14000,
      23000,
      34000,
      48000,
      64000,
      85000,
      100000,
      120000,
      140000,
      165000,
      195000,
      225000,
      265000,
      305000,
      355000
    ];

    return (level > 0 && level < 20)
        ? xpThresholds[level - 1]
        : xpThresholds.last;
  }

  int _proficiencyBonusForLevel(int level) {
    if (level >= 1 && level <= 4) return 2;
    if (level >= 5 && level <= 8) return 3;
    if (level >= 9 && level <= 12) return 4;
    if (level >= 13 && level <= 16) return 5;
    if (level >= 17 && level <= 20) return 6;
    return 2; // Default value for level 1
  }

  void _showExperienceInputDialog(BuildContext context) {
    TextEditingController xpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adjust Experience'), // Traduzido: '调整经验值' para 'Adjust Experience'
          content: TextField(
            controller: xpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter XP gained or lost"), // Traduzido: '输入获得或失去的经验值' para 'Enter XP gained or lost'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
            ),
            TextButton(
              onPressed: () {
                int deltaXP = int.tryParse(xpController.text) ?? 0;
                _updateExperience(context, deltaXP);
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'), // Traduzido: '确认' para 'Confirm'
            ),
          ],
        );
      },
    );
  }

  void _updateExperience(BuildContext context, int deltaXP) {
    CharacterManager characterManager =
    Provider.of<CharacterManager>(context, listen: false);
    int newExperience = currentExperience + deltaXP;
    int newLevel = currentLevel;

    // Check if experience is below 0
    if (newExperience < 0) {
      newExperience = 0;
    }

    // Check if experience exceeds the maximum for level 20
    int maxExperienceForLevel20 = _experienceForNextLevel(19); // XP needed to reach level 20
    if (newLevel == 20 && newExperience > maxExperienceForLevel20) {
      newExperience = maxExperienceForLevel20;
    }


    // Level up logic
    while (newLevel < 20 && newExperience >= _experienceForNextLevel(newLevel)) {
      newLevel++;
    }

    // Level down logic
    while (newLevel > 1 && newExperience < _experienceForNextLevel(newLevel - 1)) {
      newLevel--;
    }

    // Ensure experience does not exceed cap for the current level if not max level
    if (newLevel < 20) {
      int xpForNext = _experienceForNextLevel(newLevel);
      if (newExperience >= xpForNext) {
        // This case should ideally be handled by the level up logic
        // but as a safeguard, if somehow XP is more than needed for next level
        // and level up didn't occur, cap it. Or, if it's exactly the threshold,
        // it implies the character is at the brink of leveling up.
      }
    } else { // Character is level 20
      if (newExperience > maxExperienceForLevel20) {
        newExperience = maxExperienceForLevel20;
      }
    }


    characterManager.updateCharacter({
      'experiencePoints': newExperience,
      'level': newLevel,
    });
  }
}