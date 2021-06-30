import 'package:assosnation_app/components/forms/form_main_title.dart';
import 'package:assosnation_app/services/firebase/authentication/auth_service.dart';
import 'package:assosnation_app/utils/utils.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String _mail = "";
  String _pwd = "";

  _verifyAndValidateForm() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        dynamic res = await _auth.signIn(_mail, _pwd);
        if (res == null) {
          Utils.displaySnackBarWithMessage(
              context, "Failed to connect, try again", Colors.red);
        } else {
          Utils.displaySnackBarWithMessage(
              context, "Succesfully connected ! Welcome", Colors.green);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.92,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Image.asset(
                      "assets/icon/logo_an.png",
                      height: 120,
                    ),
                  ),
                  FormMainTitle("Login"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 30, 10, 0),
                    child: Column(
                      children: [
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: "Enter your email address"),
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) {
                              if (Utils.isEmailValidated(email!)) {
                                _mail = email;
                                return null;
                              } else if (email.isEmpty)
                                return "This field cannot be empty";
                              else
                                return "This email address is not valid";
                            }),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: "Enter your password"),
                          obscureText: true,
                          validator: (pwd) {
                            if (pwd == null || pwd == "")
                              return "Not a valid password";
                            _pwd = pwd;
                            return null;
                          },
                          onSaved: (pwdValue) {
                            if (pwdValue != null) {
                              setState(() => _pwd = pwdValue);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 30, 10, 0),
                    child: ElevatedButton(
                      onPressed: _verifyAndValidateForm,
                      child: Text("Connect"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
