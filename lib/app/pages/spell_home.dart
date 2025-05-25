// lib/main.dart
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../data/spell.dart';
import 'package:provider/provider.dart';
import 'spell_detail_page.dart';

class SpellListScreen extends StatefulWidget {
  const SpellListScreen({super.key});

  @override
  SpellListScreenState createState() => SpellListScreenState();
}

class SpellListScreenState extends State<SpellListScreen> {
  List<Spell> spells = [];
  List<Spell> filteredSpells = [];
  String searchQuery = '';
  String selectedClass = 'All';

  @override
  void initState() {
    super.initState();
    loadSpells();
  }

  Future<void> loadSpells() async {
    final isar = Provider.of<Isar>(context, listen: false);

    // Fetch spells from the database
    final importedSpells = await isar.spells.where().findAll();

    setState(() {
      spells = List.from(importedSpells);
      filteredSpells = spells;
    });
  }

  void filterSpells() {
    setState(() {
      filteredSpells = spells.where((spell) {
        final matchesName =
        spell.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesClass =
            selectedClass == 'All' || spell.classes.contains(selectedClass);
        return matchesName && matchesClass;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spell List'), // Traduzido: '法术列表' para 'Spell List'
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Spells', // Traduzido: '搜索法术' para 'Search Spells'
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchQuery = value;
                filterSpells();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedClass,
              onChanged: (value) {
                if (value != null) {
                  selectedClass = value;
                  filterSpells();
                }
              },
              items: <String>[
                'All',
                'Wizard', // Traduzido: '法师' para 'Wizard'
                'Sorcerer', // Traduzido: '术士' para 'Sorcerer'
                'Cleric', // Traduzido: '牧师' para 'Cleric'
                'Druid', // Traduzido: '德鲁伊' para 'Druid'
                'Ranger', // Traduzido: '游侠' para 'Ranger'
                'Paladin', // Traduzido: '圣骑士' para 'Paladin'
                'Monk', // Traduzido: '武僧' para 'Monk'
                'Barbarian', // Traduzido: '野蛮人' para 'Barbarian'
                'Bard', // Traduzido: '吟游诗人' para 'Bard'
                'Rogue', // Traduzido: '游荡者' para 'Rogue'
                // '圣武士' (Paladin) já está listado. Você pode remover a duplicata ou escolher a tradução que preferir.
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredSpells.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredSpells.length,
              itemBuilder: (context, index) {
                final spell = filteredSpells[index];
                return ListTile(
                  title: Text(spell.name),
                  subtitle: Text(
                      'Level: ${spell.level}, School: ${spell.school}'), // '环阶' para 'Level', '学派' para 'School'
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SpellDetailScreen(spell: spell),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}