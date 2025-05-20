// lib/spell_detail_screen.dart
import 'package:flutter/material.dart';
import '../data/spell.dart';
import 'package:provider/provider.dart';
import '../data/character_manager.dart';

class SpellDetailScreen extends StatelessWidget {
  final Spell spell;

  SpellDetailScreen({required this.spell});

  @override
  Widget build(BuildContext context) {
    final characterManager = Provider.of<CharacterManager>(context);
    final isFavorite =
    characterManager.character.favoriteSpells.contains(spell.name);

    void _toggleFavorite() {
      if (isFavorite) {
        characterManager.removeFavoriteSpell(spell.name);
      } else {
        characterManager.addFavoriteSpell(spell.name);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(spell.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard('Basic Information', [ // Traduzido: '基本信息' para 'Basic Information'
              _buildDetailRow('Level', spell.level), // Traduzido: '环阶' para 'Level'
              _buildDetailRow('School', spell.school), // Traduzido: '学派' para 'School'
              _buildIconDetailRow('Ritual', spell.ritual), // Traduzido: '仪式' para 'Ritual'
              _buildDetailRow('Casting Time', spell.castingTime), // Traduzido: '施法时间' para 'Casting Time'
              _buildDetailRow('Range', spell.range), // Traduzido: '施法距离' para 'Range'
              _buildDetailRow('Duration', spell.duration), // Traduzido: '持续时间' para 'Duration'
            ]),
            Divider(),
            _buildSectionCard('Casting Requirements', [ // Traduzido: '施法要求' para 'Casting Requirements'
              _buildCombinedIconDetailRow(),
              if (spell.material)
                _buildDetailRow('Material Components', spell.materialComponents), // Traduzido: '材料内容' para 'Material Components'
            ]),
            Divider(),
            _buildSectionCard('Spell Description', [ // Traduzido: '法术描述' para 'Spell Description'
              Text(spell.description, style: _contentTextStyle()),
            ]),
            Divider(),
            _buildSectionCard('Other Information', [ // Traduzido: '其他信息' para 'Other Information'
              _buildDetailRow('Class List', spell.classes.join(', ')), // Traduzido: '职业列表' para 'Class List'
              _buildDetailRow('Source', spell.source), // Traduzido: '出处' para 'Source'
              _buildDetailRow('English Name', spell.englishName), // Traduzido: '英文名' para 'English Name'
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: _sectionTitleStyle()),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: _labelTextStyle()),
          Expanded(child: Text(value, style: _contentTextStyle())),
        ],
      ),
    );
  }

  Widget _buildIconDetailRow(String label, bool value) {
    return Row(
      children: [
        Text('$label: ', style: _labelTextStyle()),
        Icon(value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red),
      ],
    );
  }

  Widget _buildCombinedIconDetailRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildIconDetailRow('Verbal', spell.verbal)), // Traduzido: '言语' para 'Verbal'
          Expanded(child: _buildIconDetailRow('Somatic', spell.somatic)), // Traduzido: '姿势' para 'Somatic'
          Expanded(child: _buildIconDetailRow('Material', spell.material)), // Traduzido: '材料' para 'Material'
        ],
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent);
  }

  TextStyle _labelTextStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  TextStyle _contentTextStyle() {
    return TextStyle(fontSize: 16);
  }
}