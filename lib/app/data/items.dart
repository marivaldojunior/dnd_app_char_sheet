import 'package:isar/isar.dart';
part 'items.g.dart';

@embedded
class Item {
  String name; // 道具名称
  int quantity; // 数量
  String description; // 描述
  double weight; // 重量
  String price; // 价格
  String type; // 类型（法术、道具、消耗品）
  String uniqueId; // 唯一标识符，用于区分同名的物品

  Item({
    this.name = 'sword', // 默认名称
    this.quantity = 1, // 默认数量
    this.description = 'A simple sword.', // 默认描述
    this.weight = 0.0, // 默认重量
    this.price = '0', // 默认价格
    this.type = 'Props', // 默认类型
  }) : uniqueId =
            DateTime.now().millisecondsSinceEpoch.toString(); // 使用时间戳字符串作为唯一标识符

  // 从JSON创建Item对象
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      quantity: json['quantity'],
      description: json['description'],
      weight: json['weight'] ?? 0.0, // 默认重量
      price: json['price'] ?? '0', // 默认价格
      type: json['type'] ?? 'Props', // 默认类型
    );
  }

  // 将Item对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'description': description,
      'weight': weight,
      'price': price,
      'type': type,
      'uniqueId': uniqueId, // 包含唯一标识符
    };
  }

  @override
  String toString() {
    return 'Name: $name, Quantity: $quantity, Description: $description, Weight: $weight, Price: $price, Type: $type, UniqueId: $uniqueId';
  }

  // 复制Item对象
  Item copyWith({
    String? name,
    int? quantity,
    String? description,
    double? weight,
    String? price,
    String? type,
  }) {
    return Item(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      price: price ?? this.price,
      type: type ?? this.type,
    );
  }
}
