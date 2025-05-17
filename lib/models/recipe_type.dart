import 'package:flutter/material.dart';

typedef RecipeTypeEntry = DropdownMenuEntry<RecipeType>;

class RecipeType {
  final int id;
  final String type;

  const RecipeType({required this.id, required this.type});

  RecipeType.fromMap(Map<String, dynamic> response)
    : id = response['id'],
      type = response['type'];

  Map<String, Object?> toMap() {
    return {'id': id, 'type': type};
  }

  @override
  String toString() {
    return 'RecipeType{id: $id, type: $type}';
  }
}
