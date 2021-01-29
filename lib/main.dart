import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:smsdispatcher/ui/input_field.dart';
import 'package:telephony/telephony.dart';
import 'package:loading_overlay/loading_overlay.dart';

void main() {
  runApp(SmsApp());
}

class SmsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SendSmsHomePage(),
    );
  }
}

class SendSmsHomePage extends StatefulWidget {

  @override
  _SendSmsHomePageState createState() => _SendSmsHomePageState();
}

class _SendSmsHomePageState extends State<SendSmsHomePage> {

  TextEditingController phoneNumberController;
  TextEditingController messageController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _loading = false;

  final Telephony telephony = Telephony.instance;
  SmsSendStatusListener listener;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    messageController     = TextEditingController();
    listener              = (SendStatus status) {
      if(status == SendStatus.SENT) {
        setState(() {
          _loading = false;
        });
        Flushbar(
          title:  "SMS Dispatcher",
          message:  "Message sent",
          duration:  Duration(seconds: 3),
        )..show(context);
      }
    };
  }

  @override
  void dispose() {
    phoneNumberController = TextEditingController();
    messageController     = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return LoadingOverlay(
      isLoading: _loading,
      child: GestureDetector(
        onTap: () {
          print("Tap");
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("SMS Dispatcher"),
          ),
          body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Form(
                    autovalidate: _autoValidate,
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField(
                          title: "Phone number",
                          hint: "ie: +598 95 000 000",
                          textColor: Colors.black,
                          icon: Icons.phone_android,
                          obscureText: false,
                          controller: phoneNumberController,
                          type: InputFieldType.phone_number,
                        ),
                        const SizedBox(height: 10,),
                        InputField(
                          title: "Message",
                          hint: "Message",
                          textColor: Colors.black,
                          icon: Icons.text_fields,
                          obscureText: false,
                          controller: messageController,
                          type: InputFieldType.message,
                        ),
                        const SizedBox(height: 10,),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.lightGreen)
                          ),
                          onPressed: onSendSmsTap,
                          color: Colors.lightGreen,
                          textColor: Colors.white,
                          child: SizedBox(
                            width: 60,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.send,
                                  size: 17,
                                ),
                                const SizedBox(width: 5,),
                                Text("Send".toUpperCase(),
                                    style: TextStyle(fontSize: 14)
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }

  void onSendSmsTap() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      print("Sending SMS");
      setState(() {
        _loading = true;
      });
      String phoneNumber = phoneNumberController.text.replaceAll(new RegExp(r'[^0-9+]'), '');
      telephony.sendSms(
          to: phoneNumber,
          message: messageController.text,
          statusListener: listener
      );
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

}
