import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_mm/modules/home_screen.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> rout) => false,
    );

Widget defaultTextFormField({
  required String formName,
  required TextEditingController controller,
  bool isPassword = false,
  String? Function(String?)? onValidate,
  Widget? suffixIcon,
  TextInputType type = TextInputType.text,
  required ThemeData theme,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        formName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0,color: theme.unselectedWidgetColor),
      ),
      const SizedBox(
        height: 10.0,
      ),
      TextFormField(
        controller: controller,
        cursorColor: Colors.orange,
        obscureText: isPassword,
        validator: onValidate,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: formName,
          hintText: formName,
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.grey[250],
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange, width: 2.0),
              borderRadius: BorderRadius.circular(10.0)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    ],
  );
}

Widget defaultDropdownFormField({
  required String formName,
  required TextEditingController controller,
  String? Function(String?)? onValidate,
  Widget? suffixIcon,
  required List<String> list,
  required ThemeData theme,
}) {
  // Set the default value to the first item in the list
  String defaultValue = list.isNotEmpty ? list[0] : '';

  // Initialize the controller with the default value if it is empty
  if (controller.text.isEmpty) {
    controller.text = defaultValue;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        formName,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: theme.unselectedWidgetColor),
      ),
      const SizedBox(
        height: 10.0,
      ),
      DropdownButtonFormField<String>(
        dropdownColor: Colors.orange,
        value: controller.text,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: Alignment.centerLeft,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.text = newValue ?? defaultValue;
        },
        validator: onValidate,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.grey[250],
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    ],
  );
}

void showToast({
  required String text,
  required ToastStates state,
}) async=>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

PreferredSizeWidget defaultAppBar(theme, context, void Function()? navigate) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: theme.primaryColor,
    title: Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: theme.unselectedWidgetColor),
          onPressed: navigate,
        ),
        const Spacer(),
        const Icon(
          Icons.fact_check_outlined,
          size: 34.0,
          color: Colors.orange,
        ),
        const SizedBox(width: 5.0),
        Text(
          'EduManage',
          style: TextStyle(
            color: theme.unselectedWidgetColor,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        const Spacer(), // To center the title
      ],
    ),
  );
}

FloatingActionButton defaultFloatingActionButton(String tooltip,
    context, ThemeData theme, void Function()? navigate) {
  return FloatingActionButton(
    onPressed: navigate,
    backgroundColor: Colors.orange,
    tooltip: tooltip,
    child: Icon(
      Icons.add,
      size: 50.0,
      color: theme.primaryColor,
    ),
  );
}
