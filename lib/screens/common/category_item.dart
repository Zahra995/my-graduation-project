import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorials_library/models/category.dart';
import 'package:tutorials_library/screens/common/files_screen.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(this.category);
  final Category category;
  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(Category root) {
    if (root.children.isEmpty) {
      return ListTile(
        title: GestureDetector(
          child: Text(root.title),
          onTap: () => Get.to(() => FilesScreen(category: root.id)),
        ),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Category>(root),
      title: Text(root.title),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(category);
  }
}
