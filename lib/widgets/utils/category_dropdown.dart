import 'package:budget_planning/icons/app_icons.dart';
import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  CategoryDropdown({Key? key, this.categoryType, required this.onChanged})
      : super(key: key);

  final String? categoryType;
  final ValueChanged<String?> onChanged;

  var appIcons = AppIcons();
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: categoryType,
        isExpanded: true,
        hint: Text('Select category'),
        items: appIcons.homeExpensesCategories
            .map(
              (e) => DropdownMenuItem<String>(
                value: e['name'],
                child: Row(
                  children: [
                    Icon(
                      e['icon'],
                      color: Colors.black54,
                    ),
                    Text(
                      e['name'],
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: onChanged);
  }
}
