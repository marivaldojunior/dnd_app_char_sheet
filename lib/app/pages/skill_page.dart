import 'package:flutter/material.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';
import 'package:provider/provider.dart';
import 'package:dnd_app_char_sheet/app/data/expertise_item.dart';

class SkillExpertiseScreen extends StatefulWidget {
  SkillExpertiseScreen({super.key});

  @override
  _SkillExpertiseScreenState createState() => _SkillExpertiseScreenState();
}

class _SkillExpertiseScreenState extends State<SkillExpertiseScreen> {
  bool _isEditMode = false;

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _addSkillOrExpertise(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddSkillOrExpertiseDialog();
      },
    );
  }

  void _deleteSkill(BuildContext context, String skill) {
    Provider.of<CharacterManager>(context, listen: false).deleteSkill(skill);
  }

  void _deleteExpertise(BuildContext context, String expertise) {
    Provider.of<CharacterManager>(context, listen: false)
        .deleteExpertise(expertise);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skills & Feats Display'), // Traduzido: '技能专长展示' para 'Skills & Feats Display'
          actions: [
            IconButton(
              icon: Icon(_isEditMode ? Icons.check : Icons.edit),
              onPressed: _toggleEditMode,
              tooltip: _isEditMode ? 'Finish Editing' : 'Edit', // '完成编辑' para 'Finish Editing', '编辑' para 'Edit'
            ),
          ],
        ),
        body: Consumer<CharacterManager>(
          builder: (context, manager, child) {
            final skills = manager.character.skills;
            final expertise = manager.character.expertise;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // No change needed
                    ),
                    child: ExpansionTile(
                      title: Text(
                        'Skills', // Traduzido: '技能' para 'Skills'
                        style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      children: skills
                          .map((skill) => Card(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(skill),
                          trailing: _isEditMode
                              ? IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                _deleteSkill(context, skill),
                            tooltip: 'Delete Skill', // '删除技能' para 'Delete Skill'
                          )
                              : null,
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // No change needed
                    ),
                    child: ExpansionTile(
                      title: Text(
                        'Non-Check Related Proficiencies/Feats', // Traduzido: '非检定相关熟练项/专长' para 'Non-Check Related Proficiencies/Feats'
                        style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      initiallyExpanded: true,
                      children: expertise
                          .map((exp) => Card(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(exp.name),
                          subtitle: Text(exp.description),
                          trailing: _isEditMode
                              ? IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () => _deleteExpertise(
                                context, exp.name),
                            tooltip: 'Delete Expertise', // '删除专长' para 'Delete Expertise'
                          )
                              : null,
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                heroTag: 'addButton',
                onPressed: () => _addSkillOrExpertise(context),
                child: Icon(Icons.add),
                tooltip: 'Add Skill or Expertise', // '添加技能或专长' para 'Add Skill or Expertise'
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddSkillOrExpertiseDialog extends StatefulWidget {
  @override
  _AddSkillOrExpertiseDialogState createState() =>
      _AddSkillOrExpertiseDialogState();
}

class _AddSkillOrExpertiseDialogState extends State<AddSkillOrExpertiseDialog> {
  bool _isAddingSkill = true;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedSkill;

// Skills list already in English-like format, assuming these are standard D&D terms
  final List<String> _skills = [
    'Constitution - Saving Throw', // Traduzido: '体质 - 豁免' para 'Constitution - Saving Throw'
    'Strength - Athletics', // Traduzido: '力量 - 运动' para 'Strength - Athletics'
    'Strength - Saving Throw', // Traduzido: '力量 - 豁免' para 'Strength - Saving Throw'
    'Dexterity - Acrobatics', // Traduzido: '敏捷 - 特技' para 'Dexterity - Acrobatics'
    'Dexterity - Sleight of Hand', // Traduzido: '敏捷 - 巧手' para 'Dexterity - Sleight of Hand'
    'Dexterity - Stealth', // Traduzido: '敏捷 - 隐匿' para 'Dexterity - Stealth'
    'Dexterity - Saving Throw', // Traduzido: '敏捷 - 豁免' para 'Dexterity - Saving Throw'
    'Intelligence - Arcana', // Traduzido: '智力 - 奥秘' para 'Intelligence - Arcana'
    'Intelligence - History', // Traduzido: '智力 - 历史' para 'Intelligence - History'
    'Intelligence - Investigation', // Traduzido: '智力 - 调查' para 'Intelligence - Investigation'
    'Intelligence - Nature', // Traduzido: '智力 - 自然' para 'Intelligence - Nature'
    'Intelligence - Religion', // Traduzido: '智力 - 宗教' para 'Intelligence - Religion'
    'Intelligence - Saving Throw', // Traduzido: '智力 - 豁免' para 'Intelligence - Saving Throw'
    'Wisdom - Animal Handling', // Traduzido: '感知 - 驯兽' para 'Wisdom - Animal Handling'
    'Wisdom - Insight', // Traduzido: '感知 - 洞悉' para 'Wisdom - Insight'
    'Wisdom - Medicine', // Traduzido: '感知 - 医药' para 'Wisdom - Medicine'
    'Wisdom - Perception', // Traduzido: '感知 - 察觉' para 'Wisdom - Perception'
    'Wisdom - Survival', // Traduzido: '感知 - 生存' para 'Wisdom - Survival'
    'Wisdom - Saving Throw', // Traduzido: '感知 - 豁免' para 'Wisdom - Saving Throw'
    'Charisma - Deception', // Traduzido: '魅力 - 欺瞒' para 'Charisma - Deception'
    'Charisma - Intimidation', // Traduzido: '魅力 - 威吓' para 'Charisma - Intimidation'
    'Charisma - Performance', // Traduzido: '魅力 - 表演' para 'Charisma - Performance'
    'Charisma - Persuasion', // Traduzido: '魅力 - 游说' para 'Charisma - Persuasion'
    'Charisma - Saving Throw', // Traduzido: '魅力 - 豁免' para 'Charisma - Saving Throw'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Skill or Expertise'), // Traduzido: '添加技能或专长' para 'Add Skill or Expertise'
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.0, // Espaçamento horizontal entre os botões
                  runSpacing: 4.0, // Espaçamento vertical entre as linhas (se houver quebra)
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Skill'), // Traduzido: '技能' para 'Skill'
                        value: true,
                        groupValue: _isAddingSkill,
                        onChanged: (value) {
                          setState(() {
                            _isAddingSkill = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Expertise/Feat'), // Traduzido: '专长' para 'Expertise/Feat' (Expertise is more common in D&D for this context)
                        value: false,
                        groupValue: _isAddingSkill,
                        onChanged: (value) {
                          setState(() {
                            _isAddingSkill = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_isAddingSkill)
                  SizedBox(
                    width:
                    double.infinity,
                    child: DropdownButton<String>(
                      value: _selectedSkill,
                      hint: Text('Select Skill'), // Traduzido: '选择技能' para 'Select Skill'
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSkill = newValue;
                        });
                      },
                      items: _skills.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded:
                      true,
                    ),
                  ),
                if (!_isAddingSkill)
                  Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'), // Traduzido: '名称' para 'Name'
                      ),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description'), // Traduzido: '描述' para 'Description'
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
          onPressed: () {
            if (_isAddingSkill) {
              if (_selectedSkill != null) {
                Provider.of<CharacterManager>(context, listen: false)
                    .addSkill(_selectedSkill!);
              }
            } else {
              if (_nameController.text.isNotEmpty) {
                Provider.of<CharacterManager>(context, listen: false)
                    .addExpertise(
                  ExpertiseItem(
                    name: _nameController.text,
                    description: _descriptionController.text,
                  ),
                );
              }
            }
            Navigator.of(context).pop();
          },
          child: Text('Add'), // Traduzido: '添加' para 'Add'
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'), // Traduzido: '取消' para 'Cancel'
        ),
      ],
    );
  }
}