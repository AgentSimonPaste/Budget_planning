import 'package:budget_planning/icons/app_icons.dart';
import 'package:budget_planning/widgets/utils/app_validator.dart';
import 'package:budget_planning/widgets/utils/category_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChangeTransactionCardForm extends StatefulWidget {
  const ChangeTransactionCardForm({Key? key, required this.data})
      : super(key: key);
  final dynamic data;
  @override
  State<ChangeTransactionCardForm> createState() =>
      _ChangeTransactionCardFormState();
}

class _ChangeTransactionCardFormState extends State<ChangeTransactionCardForm> {
  var type = 'credit';
  var category = '';
  var isLoader = false;

  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();

  final appIcons = AppIcons();
  final appValidator = AppValidator();
  var uid = const Uuid();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();

      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      int remainingAmount = userDoc['remainingAmount'];
      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];

      if (type == 'credit') {
        remainingAmount -= amount;
        totalCredit += amount;
      } else {
        remainingAmount += amount;
        totalDebit += amount;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) //?? !
          .update({
        "remainingAmount": remainingAmount,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "updateAt": timestamp,
      });

      var data = {
        'id': id,
        'title': titleEditController.text,
        'amount': amount,
        'type': type,
        'timestamp': timestamp,
        'totalCredit': totalCredit,
        'totalDebit': totalDebit,
        'remainingAmount': remainingAmount,
        'monthyear': monthyear,
        'category': category,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('transactions')
          .doc(id)
          .set(data);

      Navigator.pop(context);

      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    category = category.isNotEmpty
        ? category
        : appIcons.homeExpensesCategories[0]['name'] as String;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Сумма'),
            ),
            CategoryDropdown(
              categoryType: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            DropdownButtonFormField(
                value: 'credit',
                items: const [
                  DropdownMenuItem(
                    value: 'debit',
                    child: Text('Прибыль'),
                  ),
                  DropdownMenuItem(
                    value: 'credit',
                    child: Text('Убыток'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value;
                    });
                  }
                }),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (!isLoader) {
                  _submitForm();
                }
              },
              child: isLoader
                  ? const Center(child: CircularProgressIndicator())
                  : const Text('Добавить операцию'),
            )
          ],
        ),
      ),
    );
  }
}
