import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

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


Future createCategory(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) {
      bool isExpanded = false;
      String selectedIcon = "";
      Color categoryColor = Colors.white;
      Category category = Category.empty;
      TextEditingController categoryNameController = TextEditingController();
      bool isLoading = false;

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: BlocListener<CreateCategoryBloc, CreateCategoryState>(
          listener: (context, state) {
            if(state is CreateCategorySuccess){
              Navigator.pop(ctx);
            } else if(state is CreateCategoryLoading) {
              isLoading = true;
            }
          },
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return AlertDialog(
                title: const Text("Create a Category"),
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

                      // Icon Picker Field
                      _showCategoryTextFormField(
                        "Icon",
                        isexpanded: isExpanded,
                        prefixicon: selectedIcon,
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
                                        crossAxisSpacing: 5,
                                      ),
                                  itemCount: categoryIcons.length,
                                  itemBuilder: (context, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIcon = categoryIcons[i];
                                          isExpanded = false;
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color:
                                                selectedIcon ==
                                                    categoryIcons[i]
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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

                      // Color Picker Field
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
                            },);

                            context.read<CreateCategoryBloc>().add(
                              CreateCategory(category),
                            );

                            Navigator.pop(ctx); // Close the create dialog
                      }, showIsLoading: isLoading),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

///This method draws a textform field configured for the "Create New Category" modal.
TextFormField _showCategoryTextFormField(String hinttext, {TextEditingController? fieldController, bool readonly = true, bool isexpanded = false,
                                          Color fillcolor = Colors.white, String? prefixicon, IconData? suffixicon, Function()? ontap}) {
  bool hasprefix = false;
  if (prefixicon != null && prefixicon != "") {
    hasprefix = true;
  }

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
      prefixIcon: !hasprefix
          ? null
          : ImageIcon(
              AssetImage('assets/icons/$prefixicon.png'), // your image file
              size: 12,
              color: Colors.black54,
            ), //prefixicon != null ? prefixicon: null,//Icon(prefixicon, size: 12, color: Colors.grey) : null,
      suffixIcon: suffixicon != null
          ? Icon(suffixicon, size: 12, color: Colors.grey)
          : null,
      border: OutlineInputBorder(
        borderRadius: isexpanded
            ? BorderRadius.vertical(top: Radius.circular(12))
            : BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}


///This method shows a black Save button, used in both the screen and the followup modals
SizedBox _showSaveButton(Function()? onpressed, {bool showIsLoading=false}) {
  return SizedBox(
    width: double.infinity,
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