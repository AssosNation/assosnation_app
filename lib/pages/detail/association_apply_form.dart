import 'package:assosnation_app/components/forms/form_main_title.dart';
import 'package:assosnation_app/components/forms/form_subtitle.dart';
import 'package:assosnation_app/services/firebase/authentication/auth_service.dart';
import 'package:assosnation_app/utils/imports/commons.dart';
import 'package:assosnation_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssociationApplyForm extends StatefulWidget {
  @override
  _AssociationApplyFormState createState() => _AssociationApplyFormState();
}

class _AssociationApplyFormState extends State<AssociationApplyForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String _name = "";
  String _president = "";
  String _description = "";
  String _mail = "";
  String _phone = "";
  String _address = "";
  String _postalCode = "";
  String _city = "";
  String _pwd = "";
  String _pwd2 = "";

  _verifyAndValidateForm() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        dynamic res = await _auth.applyAsAssociation(_name, _description, _mail,
            _phone, _address, _postalCode, _city, _president, _pwd);
        if (res == null) {
          Utils.displaySnackBarWithMessage(context,
              AppLocalizations.of(context)!.error_no_infos, Colors.deepOrange);
        } else {
          Utils.displaySnackBarWithMessage(context,
              AppLocalizations.of(context)!.application_sended, Colors.green);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.92,
          height: MediaQuery.of(context).size.height * 0.92,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormMainTitle(AppLocalizations.of(context)!
                        .association_application_from_title),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 30, 10, 0),
                      child: Column(
                        children: [
                          FormSubTitle(
                              AppLocalizations.of(context)!.global_infos_label),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .enter_association_name),
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (name) {
                              if (name!.isNotEmpty) {
                                _name = name;
                                return null;
                              } else
                                return AppLocalizations.of(context)!
                                    .enter_association_name;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .enter_president_name),
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (president) {
                              if (president!.isNotEmpty) {
                                _president = president;
                                return null;
                              } else
                                return AppLocalizations.of(context)!
                                    .enter_president_name;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .enter_description),
                            keyboardType: TextInputType.multiline,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (description) {
                              if (description!.isNotEmpty) {
                                _description = description;
                                return null;
                              } else
                                return AppLocalizations.of(context)!
                                    .enter_description;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 30, 10, 0),
                      child: Column(
                        children: [
                          FormSubTitle(AppLocalizations.of(context)!
                              .connection_infos_label),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .enter_asso_email),
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (email) {
                                if (Utils.isEmailValidated(email!)) {
                                  _mail = email;
                                  return null;
                                } else if (email.isEmpty)
                                  return AppLocalizations.of(context)!
                                      .error_empty_field;
                                else
                                  return AppLocalizations.of(context)!
                                      .mail_not_valid;
                              }),
                          TextFormField(
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .enter_asso_phone),
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (phone) {
                                if (phone!.isNotEmpty) {
                                  _phone = phone;
                                  return null;
                                } else
                                  return AppLocalizations.of(context)!
                                      .enter_description;
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 30, 10, 0),
                      child: Column(
                        children: [
                          FormSubTitle(
                              AppLocalizations.of(context)!.postal_infos_label),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .enter_asso_address),
                            keyboardType: TextInputType.streetAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (address) {
                              if (address!.isNotEmpty) {
                                _address = address;
                                return null;
                              } else
                                return AppLocalizations.of(context)!
                                    .enter_asso_address;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .enter_asso_city),
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (city) {
                              if (city!.isNotEmpty) {
                                _city = city;
                                return null;
                              } else
                                return AppLocalizations.of(context)!
                                    .enter_asso_city;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .enter_asso_postal_code),
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (postalCode) {
                              if (postalCode!.isNotEmpty) {
                                _postalCode = postalCode;
                                return null;
                              } else
                                return AppLocalizations.of(context)!
                                    .enter_asso_postal_code;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 30, 10, 0),
                      child: Column(
                        children: [
                          FormSubTitle(AppLocalizations.of(context)!
                              .connection_infos_label),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .pwd_input_placeholder),
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (pwd) {
                              if (pwd!.isNotEmpty) {
                                _pwd = pwd;
                                return null;
                              } else
                                return AppLocalizations.of(context)!
                                    .enter_password;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .pwd_input_confirm_placeholder),
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (pwd2) {
                              if (pwd2!.isNotEmpty && pwd2 == _pwd) {
                                _pwd2 = pwd2;
                                return null;
                              } else
                                return AppLocalizations.of(context)!
                                    .passwords_not_matched;
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 150, 10, 0),
                      child: ElevatedButton(
                        onPressed: _verifyAndValidateForm,
                        child: Text(
                            AppLocalizations.of(context)!.send_application),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
