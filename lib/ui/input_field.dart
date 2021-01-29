import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputFieldType {
  phone_number,
  message,
}

class InputField extends StatelessWidget {

  InputField({
    @required this.textColor,
    @required this.title,
    @required this.hint,
    @required this.icon,
    @required this.controller,
    @required this.obscureText,
    @required this.type,
  });

  final String title;
  final String hint;
  final Color textColor;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final InputFieldType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            title,
            style: TextStyle(color: textColor, fontSize: 16.0),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: textColor.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Icon(
                  icon,
                  color: textColor,
                ),
              ),
              Container(
                height: 30.0,
                width: 1.0,
                color: textColor.withOpacity(0.5),
                margin: EdgeInsets.only(left: 00.0, right: 10.0),
              ),
              Container(
                width: 200,
                height: (type == InputFieldType.message) ? 100 : 55,
                child: Center(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.all(0)
                    ),
                    obscureText: obscureText ?? false,
                    validator: getInputValidator(),
                    keyboardType: getInputType(),
                    controller: controller,
                    maxLines: (type == InputFieldType.message) ? 3 : 1,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Function getInputValidator() {
    switch(type) {
      case InputFieldType.phone_number:
        return (String value) {
          String phoneNumber = value.replaceAll(new RegExp(r'[^0-9+]'), '');
          if (value.isEmpty || phoneNumber.length < 12) {
            return 'Please type a valid phone number';
          }
          return null;
        };
      case InputFieldType.message:
        return (String value) {
          if (value.isEmpty || value.length < 2) {
            return 'Please type a valid message';
          }
          return null;
        };
    }
  }

  TextInputType getInputType() {
    switch(type) {
      case InputFieldType.phone_number:
        return TextInputType.phone;
      case InputFieldType.message:
        return TextInputType.multiline;
    }
    return TextInputType.text;
  }
}