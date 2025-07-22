import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
  List<String> categoryIcons = [
    'distance',
    'food',
    'fast-food',
    'game-controller',
    'healthcare',
    'money',
    'open-book',
    'plane',
    'receipt',
    'shopping-bag',
  ];

  @override
  void initState(){
    dateController.text = DateFormat('dd/MM/yyyy').format(_savedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      
        body: _showForm(context),
      
      ),
    );
  }

  SingleChildScrollView _showForm(BuildContext context){

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            Text("Add Expense", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

            //EXPENSE AMOUNT FIELD
            _showTextfield(expenseController, 0.7, "", false, 30, FontAwesomeIcons.dollarSign, (){}, null),    

            const SizedBox(height: 32),
//------------------------------------------------
            
            //CATEGORY FIELD
            _showTextfield( categoryController, 1, "Category", true, 12, FontAwesomeIcons.list, (){}, IconButton (
                onPressed: () {
                  //showDialog(context: context, builder: (ctx){
                    _createCategory(context);   //------------ CREATE A NEW CATEGORY
                  //}
                  //);
                },
                icon: Icon(FontAwesomeIcons.circlePlus, size: 16, color: Colors.grey)
              )
            ),

            const SizedBox(height: 16),
//------------------------------------------------

            //DATE FIELD
            _showTextfield(dateController, 1, "Date", true, 12, FontAwesomeIcons.clock, 
                () async {
                  DateTime? newDate = await showDatePicker(context: context, initialDate: _savedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365)));

                  if(newDate != null){
                    setState(() {
                      dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
                      _savedDate = newDate;
                    });
                  }
                },

            null ),

            const SizedBox(height: 128),
//------------------------------------------------

            //SAVE BUTTON
            _showSaveButton(null),
           
          ]
      
        ),
      ),
    );
  }


  SizedBox _showTextfield(TextEditingController controller, double boxwidth, String hinttext, bool isreadonly, double borderradius, IconData? prefixicon, GestureTapCallback? onTap, IconButton? suffixiconbutton){
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
            borderSide: BorderSide.none
          )
        ),
      ),
    );
            
  }


 Future _createCategory(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) {
      bool isExpanded = false;
      String selectedIcon = "";
      Color categoryColor = Colors.white;
      Category category = Category.empty;
      TextEditingController categoryNameController = TextEditingController();

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text("Create a Category"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name Field
                    _showCategoryTextFormField(
                      "Name",
                      fieldController: categoryNameController,
                      readonly: false,
                    ),

                    const SizedBox(height: 16),

                    // Icon Picker Toggle
                    _showCategoryTextFormField(
                      "Icon",
                      isexpanded: isExpanded,
                      suffixicon: FontAwesomeIcons.chevronDown,
                      ontap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),

                    // Icon Picker Grid
                    isExpanded
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5),
                                itemCount: categoryIcons.length,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIcon = categoryIcons[i];
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3,
                                          color: selectedIcon ==
                                                  categoryIcons[i]
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/icons/${categoryIcons[i]}.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(),

                    const SizedBox(height: 16),

                    // Color Picker Trigger
                    _showCategoryTextFormField(
                      "Colour",
                      readonly: true,
                      fillcolor: categoryColor,
                      ontap: () {
                        showDialog(
                          context: context,
                          builder: (ctx2) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ColorPicker(
                                    pickerColor: Colors.white,
                                    pickerAreaHeightPercent: 0.8,
                                    onColorChanged: (value) {
                                      setState(() {
                                        categoryColor = value;
                                      });
                                    },
                                  ),
                                  _showSaveButton(() {
                                    Navigator.pop(ctx2);
                                  }),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    _showSaveButton(() {
                      setState(() {
                        category.categoryID = const Uuid().v1();
                        category.name = categoryNameController.text;
                        category.icon = selectedIcon;
                        category.color = categoryColor.toString();
                      });

                      context
                          .read<CreateCategoryBloc>()
                          .add(CreateCategory(category));

                      Navigator.pop(ctx); // Close the create dialog
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

  

  ///This method draws a textform field configured for the "Create New Category" modal.
  TextFormField _showCategoryTextFormField(String hinttext, { TextEditingController? fieldController, bool readonly = true, bool isexpanded=false, Color fillcolor=Colors.white, IconData? suffixicon=null, Function()? ontap=null}){
    return TextFormField(
      controller: fieldController,
      onTap: ontap,
      textAlignVertical: TextAlignVertical.center,
      readOnly: readonly,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fillcolor,
        hintText: hinttext,
        suffixIcon: suffixicon != null ? Icon(suffixicon, size: 12, color: Colors.grey) : null,
        border: OutlineInputBorder(
          borderRadius: isexpanded
          ? BorderRadius.vertical(
            top: Radius.circular(12),
          )
          : BorderRadius.circular(12),
          borderSide: BorderSide.none
        )
      ), 
    );
  }


///This method shows a black Save button, used in both the screen and the followup modals
SizedBox _showSaveButton(Function()? onpressed){
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.5,
    height: 50,
    child: TextButton(
      onPressed: onpressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        )
      ),
      child: const Text("Save", style: TextStyle(fontSize: 20, color: Colors.white))
    )
  );
 }


}