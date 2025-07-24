import 'package:expense_tracker/screens/add_expense/views/category_creation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime _savedDate = DateTime.now();

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(_savedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,

        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),

        body: _showForm(context),
      ),
    );
  }

  SingleChildScrollView _showForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
              "Add Expense",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            //-------------------------
            _showTextfield(expenseController, 0.7, "", false, 30, FontAwesomeIcons.dollarSign, () {}, null), //EXPENSE AMOUNT FIELD
            const SizedBox(height: 32),
            //--------------------------
            _showTextfield(categoryController, 1, "Category", true, 12, FontAwesomeIcons.list, () {}, IconButton(
                //CATEGORY FIELD
                onPressed: () { createCategory(context); }, //------------ CREATE A NEW CATEGORY
                icon: Icon(FontAwesomeIcons.circlePlus, size: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            //--------------------------
            _showTextfield(dateController, 1, "Date", true, 12, FontAwesomeIcons.clock, //DATE FIELD
              () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: _savedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                if (newDate != null) {
                  setState(() {
                    dateController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(newDate);
                    _savedDate = newDate;
                  });
                }
              },

              null,
            ),
            const SizedBox(height: 128),
            //--------------------------
            _showSaveButton(null), //SAVE BUTTON
          ],
        ),
      ),
    );
  }

  SizedBox _showTextfield(
    TextEditingController controller,
    double boxwidth,
    String hinttext,
    bool isreadonly,
    double borderradius,
    IconData? prefixicon,
    GestureTapCallback? onTap,
    IconButton? suffixiconbutton,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * boxwidth,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixicon, size: 16, color: Colors.grey),
          suffixIcon: suffixiconbutton,
          filled: true,
          fillColor: Colors.white,
          hintText: hinttext,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderradius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  ///This method shows a black Save button, used in both the screen and the followup modals
  SizedBox _showSaveButton(Function()? onpressed, {bool showIsLoading=false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 50,
      child: showIsLoading
      ? const Center(
          child: CircularProgressIndicator()
      )
      : TextButton(
        onPressed: onpressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Save",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
  
}
