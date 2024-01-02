import 'package:budget_planning/widgets/cards/transaction_list.dart';
import 'package:flutter/material.dart';

class TypeTabBar extends StatelessWidget {
  const TypeTabBar({Key? key, required this.category, required this.monthYear})
      : super(key: key);
  final String category;

  final String monthYear;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(
              text: "Прибыль",
            ),
            Tab(
              text: "Убытки",
            ),
          ]),
          Expanded(
              child: TabBarView(children: [
            TransactionList(
              category: category,
              type: 'debit',
              monthYear: monthYear,
            ),
            TransactionList(
              category: category,
              type: 'credit',
              monthYear: monthYear,
            ),
          ])),
        ],
      ),
    ));
  }
}
