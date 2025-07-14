import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  String _selectedIcon = "";

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
            showTextfield(expenseController, 0.7, "", false, 30, FontAwesomeIcons.dollarSign, (){}, null),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.7,
            //   child: TextFormField(
            //     controller: expenseController,
            //     //onTap: (value){

            //    // },
            //     decoration: InputDecoration(
            //       prefixIcon: Icon(FontAwesomeIcons.dollarSign, size: 16, color: Colors.grey,),
            //       filled: true,
            //       fillColor: Colors.white,
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30),
            //         borderSide: BorderSide.none
            //       )
            //     ),
            //   ),
            // ),      

            const SizedBox(height: 32),
//------------------------------------------------
            
            //CATEGORY FIELD
            showTextfield( categoryController, 1, "Category", true, 12, FontAwesomeIcons.list, (){}, IconButton (
                onPressed: () {
                  showDialog(context: context, builder: (ctx){

                    return createCategory(ctx);
                    }
                  );
                },

                icon: Icon(FontAwesomeIcons.circlePlus, size: 16, color: Colors.grey)
                )
            ),

            const SizedBox(height: 16),
//------------------------------------------------

            //DATE FIELD
            showTextfield(dateController, 1, "Date", true, 12, FontAwesomeIcons.clock, 
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

            // SizedBox(
            //   child: TextFormField(
            //     controller: dateController,
            //     textAlignVertical: TextAlignVertical.center,
            //     readOnly: true,

            //     onTap: () async {
            //       DateTime? newDate = await showDatePicker(context: context, initialDate: _savedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365)));

            //       if(newDate != null){
            //         setState(() {
            //           dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
            //           _savedDate = newDate;
            //         });
            //       }
            //     },

            //     decoration: InputDecoration(
            //       prefixIcon: Icon(FontAwesomeIcons.clock, size: 16, color: Colors.grey,),
            //       filled: true,
            //       fillColor: Colors.white,
            //       hintText: "Date",
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(12),
            //         borderSide: BorderSide.none
            //       )
            //     ),
            //   ),
            // ),

            const SizedBox(height: 32),

            //SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: kToolbarHeight,
              child: TextButton(
                onPressed: (){},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
                child: const Text("Save", style: TextStyle(fontSize: 22, color: Colors.white))
              )
            ),
          ]
      
        ),
      ),
    );
  }


  SizedBox showTextfield(TextEditingController controller, double boxwidth, String hinttext, bool isreadonly, double borderradius, IconData? prefixicon, GestureTapCallback? onTap, IconButton? suffixiconbutton){
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

//  SizedBox(
//     width: MediaQuery.of(context).size.width * 0.7,
//     child: TextFormField(
//       controller: expenseController,
//       //onTap: (value){

//       // },
//       decoration: InputDecoration(
//         prefixIcon: Icon(FontAwesomeIcons.dollarSign, size: 16, color: Colors.grey,),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none
//         )
//       ),
//     ),
//   ),      



  StatefulBuilder createCategory(BuildContext ctx) {
    bool isExpanded = false;
    Color _pickedColor = Colors.white;

    return StatefulBuilder(
      builder: (context, setState) {

        return AlertDialog (
            title: Text("Create a Category"),
            content: Column (
              mainAxisSize: MainAxisSize.min,  //Make the column as small as possible, while still showing the children
              children: [
                
                //SELECT NAME
                TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: false,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none
                    )
                  ), 
                ),
        
                const SizedBox(height: 16),
        
                //SELECT ICON
                TextFormField(
                  onTap: (){
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Icon",
                    suffixIcon: Icon(FontAwesomeIcons.chevronDown, size: 12, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: isExpanded
                    ? BorderRadius.vertical(
                      top: Radius.circular(12),
                    )
                    : BorderRadius.circular(12),
                      borderSide: BorderSide.none
                    )
                  ), 
                ),

                //Show Icon Picker?
                isExpanded
                ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    )
                  ),
                
                //Icon list
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
                    itemCount: categoryIcons.length,
                    itemBuilder: (context, int i){
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            _selectedIcon = categoryIcons[i];
                          },);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: _selectedIcon == categoryIcons[i] ? Colors.green : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(image: AssetImage('assets/icons/${categoryIcons[i]}.png'))
                          ),
                        ),
                      );
                    }
                  
                  ),
                )
              )
              : Container(),
        
                const SizedBox(height: 16),
        
                //SELECT COLOUR
                TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: true,
                  onTap: () {
                    showDialog(context: context,
                      builder: (ctx2){

                        return AlertDialog (
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ColorPicker( pickerColor:_pickedColor, onColorChanged: (value) {


                              }),

                              //COLOR SAVE BUTTON
                              // SizedBox(
                              //   width: double.infinity,
                              //   height: 50,
                              //   child: TextButton(
                              //     onPressed: (){
                              //       Navigator.pop(ctx2);
                              //     },
                              //     style: TextButton.styleFrom(
                              //       backgroundColor: Colors.black,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(12)
                              //       )
                              //     ),
                              //     child: const Text("Save", style: TextStyle(fontSize: 22, color: Colors.white))
                              //   )
                              // ),

                            ],
                          ),
                        );

                      }
                    );
                  },

                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Colour",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none
                    )
                  ), 
                ),
        
              ]
            ),
          );

      }
    );

  }



}