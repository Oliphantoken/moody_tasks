import 'package:moody_tasks/config/injection.dart';
import 'package:moody_tasks/utils/config_controller.dart';
import 'package:flutter/material.dart';

enum VALIDATIONTYPE{
  text,
  number,
  date,
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final ConfigController _configController;
  double? weeklyHoursGoal = 10;
  String saveLabel = 'Save';
  bool _isFormValid = false;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _weeklyGoalController;
  late final TextEditingController _themeController;

  @override
  void initState() {
    _configController = getIt<ConfigController>();
    _usernameController = TextEditingController(text: _configController.config.userName ?? '');
    _weeklyGoalController = TextEditingController(text:  _configController.config.weeklyHoursGoal?.toString() ?? '10.0');
    _themeController = TextEditingController(text: _configController.config.theme?.toString() ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(title: const Text('Settings')),
        body: _buildPhoneLayout(context),
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 16, 25.0, 32),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (){
            setState(() {
              _isFormValid = _formKey.currentState?.validate() ?? false;
              if(!_isFormValid){ saveLabel = 'Save'; }
            });
          },
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What do you want me to call you?', style: TextStyle(fontSize: 14)),
              _showTextFormfield(_usernameController, 0.4, 'User name', false, 10, Icons.person, fieldType: VALIDATIONTYPE.text),
          
              SizedBox(height: 40),
              
              Text('Your weekly goal for minimum work hours:', style: TextStyle(fontSize: 14)),
              _showTextFormfield(_weeklyGoalController, 0.4, '10', false, 10, Icons.timer, fieldType: VALIDATIONTYPE.number, keyboardType: TextInputType.numberWithOptions(decimal: true)),
          
              SizedBox(height: 100),

              Text('Which colour scheme do you want to use?', style: TextStyle(fontSize: 14)),
              DropdownMenuFormField(
                leadingIcon: Icon(Icons.color_lens),
                width: 200,
                controller: _themeController,
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 'Light', label: 'Light theme'),
                  DropdownMenuEntry(value: 'Dark', label: 'Dark theme'),
                ]
              ),
          
              SizedBox(height: 100),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ _showSaveButton(saveLabel, 0.4) ]
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _showTextFormfield(
    TextEditingController controller,
    double boxwidth,
    String hinttext,
    bool isreadonly,
    double borderradius,
    IconData prefixicon, {
    VALIDATIONTYPE? fieldType,
    GestureTapCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * boxwidth,
      height: 50,
      child: TextFormField(
        keyboardType: keyboardType,
        validator: (value){
          switch(fieldType){
            case VALIDATIONTYPE.text:
              if (value == null || value.trim().isEmpty) {
                return 'This needs a text!';
              } 
              return null;
            case VALIDATIONTYPE.number:
              // Handle null/empty (optional field) - return null (valid)
              if (value == null || value.isEmpty){
                return 'Enter valid duration > 0';
              }
              // Now value is definitely non-null, so parse safely
              final numValue = double.tryParse(value);
              if (numValue == null || numValue <= 0) {
                return 'Enter valid duration > 0';
              }
              return null;

            case VALIDATIONTYPE.date: break;
            default: break;
          }
          return null;
        },
        style: TextStyle(fontSize: 14, color: Colors.black87),
        controller: controller,
        readOnly: isreadonly,
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          prefixIcon: Icon(prefixicon, size: 24, color: Colors.grey[800]),
          filled: true,
          fillColor: Colors.white,
          hintText: hinttext,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderradius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  SizedBox _showSaveButton(String buttontext,double size) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * size,
      height: 50,
      child: TextButton(
        onPressed: _isFormValid? () async {
          try {
            final goal = double.parse(_weeklyGoalController.text.trim());
            await _configController.update(
              userName: _usernameController.text.trim(),
              weeklyHoursGoal: goal,
              theme: _themeController.text.trim(),
            );
            setState(() {
              saveLabel = "Saved!";
            });
          } catch(e) {
            print('SettingsScreen: error saving settings: $e');
          }
        } : null,

        style: TextButton.styleFrom(
          backgroundColor: _isFormValid ? Theme.of(context).colorScheme.primary : Colors.grey[300],
          foregroundColor: _isFormValid ? Colors.white : Colors.grey[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttontext,
          style: TextStyle(fontSize: 14, color: _isFormValid? Colors.white : Colors.grey),
        ),
      ),
    );
  }
   
}