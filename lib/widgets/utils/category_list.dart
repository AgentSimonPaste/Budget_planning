import 'package:budget_planning/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key, required this.onChanged}) : super(key: key);
  final ValueChanged<String?> onChanged;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currentCategory = "";
  List<Map<String, dynamic>> categoryList = [];

  final scrollController = ScrollController();
  var appIcons = AppIcons();

  var addCategory = {
    "name": "All",
    "icon": FontAwesomeIcons.cartPlus,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      categoryList = appIcons.homeExpensesCategories;
      categoryList.insert(0, addCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: ListView.builder(
        controller: scrollController,
        itemCount: categoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var data = categoryList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                currentCategory = data['name'];
                widget.onChanged(data['name']);
              });
            },
            child: Container(
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: currentCategory == data['name']
                    ? Colors.blue.shade900.withOpacity(0.7)
                    : Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Row(
                children: [
                  Icon(
                    data['icon'],
                    size: 15,
                    color: currentCategory == data['name']
                        ? Colors.white
                        : Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    data['name'],
                    style: TextStyle(
                      color: currentCategory == data['name']
                          ? Colors.white
                          : Colors.blue,
                    ),
                  ),
                ],
              )),
            ),
          );
        },
      ),
    );
  }
}
