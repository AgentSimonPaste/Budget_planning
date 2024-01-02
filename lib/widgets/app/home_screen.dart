// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:budget_planning/forms/alertForms/alerts.dart';
import 'package:budget_planning/widgets/auth/log_in.dart';
import 'package:budget_planning/widgets/cards/hero_card.dart';
import 'package:budget_planning/widgets/cards/transactions_card.dart';
import 'package:budget_planning/forms/add_transaction_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoading = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final alertForm = AlertForm();

  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Главная',
          style: Theme.of(context).typography.white.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: isLogoutLoading
                ? const CircularProgressIndicator()
                : const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroCard(
              userId: userId,
            ),
            TransactionSCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          alertForm.dialogBuilder(context, AddTransactionForm());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
