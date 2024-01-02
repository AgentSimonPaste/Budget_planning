import 'package:budget_planning/icons/app_icons.dart';
import 'package:budget_planning/widgets/utils/app_validator.dart';
import 'package:budget_planning/widgets/utils/category_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChangeBalanceForm extends StatefulWidget {
  const ChangeBalanceForm({Key? key}) : super(key: key);

  @override
  State<ChangeBalanceForm> createState() => _ChangeBalanceFormState();
}

class _ChangeBalanceFormState extends State<ChangeBalanceForm> {
  var isLoader = false;

  var amountEditController = TextEditingController();

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

      int remainingAmount = int.parse(amountEditController.text);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        "remainingAmount": remainingAmount,
      });

      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions');

      final querySnapshot = await collectionReference.get();

      final documents = querySnapshot.docs;

      documents.forEach((document) async {
        final DocumentReference documentReference =
            collectionReference.doc(document.id);

        await documentReference.update({'remainingAmount': remainingAmount});
      });

      Navigator.pop(context);

      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Сумма'),
            ),
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
                  : const Text('Обновить баланс'),
            )
          ],
        ),
      ),
    );
  }
}
