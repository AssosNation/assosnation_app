import 'package:assosnation_app/pages/detail/signin_form.dart';
import 'package:assosnation_app/utils/imports/commons.dart';
import 'package:flutter/material.dart';

import 'detail/signup_form.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var _isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => setState(() => _isSigningUp = false),
                  child: Text(AppLocalizations.of(context)!.signin_label)),
              ElevatedButton(
                  onPressed: () => setState(() => _isSigningUp = true),
                  child: Text(AppLocalizations.of(context)!.signup_label)),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isSigningUp == false ? SignInForm() : SignUpForm(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
