// 龙与地下城角色数据模型
// 包含血量、生命值、种族、职业、骰子袋、背包

import 'package:dnd_app_char_sheet/app/data/diceset.dart';
import 'package:isar/isar.dart';
import 'items.dart';
import 'expertise_item.dart';
import 'consumable.dart';

part 'character.g.dart';

@collection
class Character {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String name;
  String race;
  String characterClass;
  String background;
  String alignment;
  int level;
  int experiencePoints;
  List<int> attributes; // 六维属性列表，顺序为：力量、敏捷、体质、智力、感知、魅力
  int currentHitPoints;
  int maxHitPoints;
  int temporaryHitPoints; // 新增临时生命值属性
  int armorClass;
  int initiative;
  int speed;
  List<int> coin; // [gold, silver, copper]
  String avatarUrl;
  List<DiceSet> diceBag; // 新增骰子袋属性
  List<Item> backpack; // 新增背包属性
  List<String> skills; // 新增技能属性
  List<ExpertiseItem> expertise; // 新增专长属性
  List<String> favoriteSpells = []; // New property to store favorite spells
  List<Consumable> consumables = []; // New property to store consumables
  Character({
    required this.name,
    required this.race,
    required this.characterClass,
    required this.background,
    required this.alignment,
    this.level = 1,
    this.experiencePoints = 0,
    required this.attributes,
    required this.currentHitPoints,
    required this.maxHitPoints,
    this.temporaryHitPoints = 0, // 初始化临时生命值
    required this.armorClass,
    required this.initiative,
    required this.speed,
    List<int> coin = const [0, 0, 0],
    this.avatarUrl = '',
    List<DiceSet> diceBag = const [],
    List<Item> backpack = const [],
    List<String> skills = const [],
    List<ExpertiseItem> expertise = const [],
    List<String> favoriteSpells = const [],
    List<Consumable> consumables = const [],
  })  : coin = coin.toList(),
        diceBag = diceBag.toList(),
        backpack = backpack.toList(),
        skills = skills.toList(),
        expertise = expertise.toList(),
        favoriteSpells = favoriteSpells.toList(),
        consumables = consumables.toList();

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      race: json['race'],
      characterClass: json['characterClass'],
      background: json['background'],
      alignment: json['alignment'],
      level: json['level'],
      experiencePoints: json['experiencePoints'],
      attributes: List<int>.from(json['attributes']),
      currentHitPoints: json['currentHitPoints'],
      maxHitPoints: json['maxHitPoints'],
      temporaryHitPoints: json['temporaryHitPoints'] ?? 0, // 从JSON中获取临时生命值
      armorClass: json['armorClass'],
      initiative: json['initiative'],
      speed: json['speed'],
      coin: List<int>.from(json['coin']),
      avatarUrl: json['avatarUrl'],
      diceBag: (json['diceBag'] as List<dynamic>?)
              ?.map((e) => DiceSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      backpack: (json['backpack'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      skills: List<String>.from(json['skills'] ?? []), // 从JSON中获取技能
      expertise: (json['expertise'] as List<dynamic>?)
              ?.map((e) => ExpertiseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [], // 从JSON中获取专长
      favoriteSpells: List<String>.from(json['favoriteSpells'] ?? []),
      consumables: (json['consumables'] as List<dynamic>?)
              ?.map((e) => Consumable.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [], // 从JSON中获取消耗品
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'race': race,
      'characterClass': characterClass,
      'background': background,
      'alignment': alignment,
      'level': level,
      'experiencePoints': experiencePoints,
      'attributes': attributes,
      'currentHitPoints': currentHitPoints,
      'maxHitPoints': maxHitPoints,
      'temporaryHitPoints': temporaryHitPoints, // 将临时生命值转换为JSON
      'armorClass': armorClass,
      'initiative': initiative,
      'speed': speed,
      'coin': coin,
      'avatarUrl': avatarUrl,
      'diceBag': diceBag.map((diceSet) => diceSet.toJson()).toList(),
      'backpack': backpack.map((item) => item.toJson()).toList(),
      'skills': skills, // 将技能转换为JSON
      'expertise': expertise
          .map((expertiseItem) => expertiseItem.toJson())
          .toList(), // 将专长转换为JSON
      'favoriteSpells': favoriteSpells,
      'consumables':
          consumables.map((consumable) => consumable.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Name: $name\n'
        'Race: $race\n'
        'Class: $characterClass\n'
        'Background: $background\n'
        'Alignment: $alignment\n'
        'Level: $level\n'
        'Experience Points: $experiencePoints\n'
        'Attributes: $attributes\n'
        'HP: $currentHitPoints/$maxHitPoints, Temporary HP: $temporaryHitPoints, AC: $armorClass, Initiative: $initiative, Speed: $speed\n' // 添加临时生命值到字符串表示
        'Coin (Gold, Silver, Copper): ${coin[0]}, ${coin[1]}, ${coin[2]}\n'
        'Avatar: $avatarUrl\n'
        'Dice Bag: ${diceBag.map((diceSet) => diceSet.toString()).join(', ')}\n'
        'Backpack: ${backpack.map((item) => item.toString()).join(', ')}\n'
        'Skills: ${skills.join(', ')}\n' // 添加技能到字符串表示
        'Expertise: ${expertise.map((expertiseItem) => expertiseItem.toString()).join(', ')}\n' // 添加专长到字符串表示
        'Consumables: ${consumables.map((consumable) => consumable.toString()).join(', ')}'; // 添加消耗品到字符串表示
  }

  // Factory constructor to create a default empty character
  factory Character.empty() {
    return Character(
      name: 'Unnamed Hero',
      race: 'Human',
      characterClass: 'Warrior',
      background: 'Soldier',
      alignment: 'Lawful Good',
      level: 1,
      experiencePoints: 25,
      attributes: [10, 10, 10, 10, 10, 10], // 初始化六维属性
      currentHitPoints: 8,
      maxHitPoints: 10,
      temporaryHitPoints: 0, // 初始化临时生命值
      armorClass: 10,
      initiative: 10,
      speed: 30,
      coin: [20, 15, 10],
      avatarUrl: '',
      diceBag: [
        DiceSet.standard(),
      ], // 添加标准骰子组
      backpack: [
        Item(name: 'Sword', quantity: 1, description: 'A sharp blade')
      ], // 初始化空背包
      skills: ['Constitution - Immunity'],
      expertise: [ExpertiseItem(name: 'A musical instrument', description: 'Flute')], // 初始化专长
      favoriteSpells: [], // Initialize with an empty list
      consumables: [], // Initialize with an empty list
    );
  }

  // CopyWith method to create a new character with updated values
  Character copyWith({
    String? name,
    String? race,
    String? characterClass,
    String? background,
    String? alignment,
    int? level,
    int? experiencePoints,
    List<int>? attributes,
    int? currentHitPoints,
    int? maxHitPoints,
    int? temporaryHitPoints, // 添加临时生命值到copyWith方法
    int? armorClass,
    int? initiative,
    int? speed,
    List<int>? coin,
    String? avatarUrl,
    List<DiceSet>? diceBag,
    List<Item>? backpack,
    List<String>? skills,
    List<ExpertiseItem>? expertise,
    List<String>? favoriteSpells,
    List<Consumable>? consumables,
  }) {
    return Character(
      name: name ?? this.name,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      background: background ?? this.background,
      alignment: alignment ?? this.alignment,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      attributes: attributes ?? this.attributes,
      currentHitPoints: currentHitPoints ?? this.currentHitPoints,
      maxHitPoints: maxHitPoints ?? this.maxHitPoints,
      temporaryHitPoints:
          temporaryHitPoints ?? this.temporaryHitPoints, // 添加临时生命值到copyWith方法
      armorClass: armorClass ?? this.armorClass,
      initiative: initiative ?? this.initiative,
      speed: speed ?? this.speed,
      coin: coin ?? this.coin,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      diceBag: diceBag ?? this.diceBag,
      backpack: backpack ?? this.backpack,
      skills: skills ?? this.skills, // 添加技能到copyWith方法
      expertise: expertise ?? this.expertise, // 添加专长到copyWith方法
      favoriteSpells: favoriteSpells ?? this.favoriteSpells,
      consumables: consumables ?? this.consumables,
    );
  }
}
