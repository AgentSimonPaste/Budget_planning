import 'package:budget_planning/forms/alertForms/alerts.dart';
import 'package:budget_planning/forms/change_balance_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  HeroCard({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          debugPrint('ERROOORRRRRRRRRRR: ${snapshot.error}');
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;

        return Cards(
          data: data,
        );
      },
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.data,
  });

  final Map data;

  @override
  Widget build(BuildContext context) {
    final alertForm = AlertForm();
    final theme = Theme.of(context);
    return Container(
      color: Colors.blue.shade400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Баланс',
                  style: theme.typography.white.headlineLarge,
                ),
                Row(
                  children: [
                    Text(
                      '${data['remainingAmount']} Br',
                      style: theme.typography.white.headlineMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        alertForm.dialogBuilder(context, ChangeBalanceForm());
                      },
                      icon: const Icon(Icons.edit),
                      style: theme.iconButtonTheme.style,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            padding:
                const EdgeInsets.only(left: 10, top: 30, right: 10, bottom: 10),
            child: Row(
              children: [
                CardBalance(
                  header: 'Прибыль',
                  amount: '${data['totalDebit']} Br',
                  color: Colors.green.shade400,
                  icon: Icons.arrow_upward,
                ),
                const SizedBox(width: 15),
                CardBalance(
                  header: 'Убытки',
                  amount: '${data['totalCredit']} Br',
                  color: Colors.red.shade400,
                  icon: Icons.arrow_downward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardBalance extends StatelessWidget {
  const CardBalance({
    super.key,
    required this.header,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String header;
  final String amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(header),
                  Text(amount),
                ],
              ),
              const Spacer(),
              Icon(
                icon,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
