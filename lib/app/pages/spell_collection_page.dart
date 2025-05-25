import 'package:dnd_app_char_sheet/app/pages/spell_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';
import 'package:dnd_app_char_sheet/app/data/spell.dart';
import 'package:dnd_app_char_sheet/app/pages/spell_home.dart';
import 'package:isar/isar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SpellCollectionScreen extends StatelessWidget {
  const SpellCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spell Collection'), // Traduzido: '法术收藏' para 'Spell Collection'
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpellListScreen()),
              );
            },
            tooltip: 'Search and Add Spells', // Traduzido: '搜索和添加法术' para 'Search and Add Spells'
          ),
        ],
      ),
      body: Consumer<CharacterManager>(
        builder: (context, characterManager, child) {
          final favoriteSpells = characterManager.character.favoriteSpells;

          if (favoriteSpells.isEmpty) {
            return const Center(
              child: Text('No collected spells'), // Traduzido: '没有收藏的法术' para 'No collected spells'
            );
          }

          return FutureBuilder<List<Spell>>(
            future: _getFavoriteSpells(context, favoriteSpells),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error loading spells')); // Traduzido: '加载法术时出错' para 'Error loading spells'
              }

              final spells = snapshot.data!;

              return MasonryGridView.count(
                crossAxisCount: 2, // Two spells per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                padding: const EdgeInsets.all(16.0),
                itemCount: spells.length,
                itemBuilder: (context, index) {
                  final spell = spells[index];

                  return Card(
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SpellDetailScreen(spell: spell),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spell.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text('Level: ${spell.level}'), // Traduzido: '环阶' para 'Level'
                            Text('School: ${spell.school}'), // Traduzido: '学派' para 'School'
                            Text('Casting Time: ${spell.castingTime}'), // Traduzido: '施法时间' para 'Casting Time'
                            Text('Range: ${spell.range}'), // Traduzido: '施法距离' para 'Range'
                            Text('Duration: ${spell.duration}'), // Traduzido: '持续时间' para 'Duration'
                          ],
                        ),
                      ),
                    ),
                  );
                },
                //staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Spell>> _getFavoriteSpells(
      BuildContext context, List<String> favoriteSpells) async {
    final isar = Provider.of<Isar>(context, listen: false);
    final spells = await isar.spells
        .filter()
        .anyOf(favoriteSpells, (q, String name) => q.nameEqualTo(name))
        .findAll();
    return spells;
  }
}