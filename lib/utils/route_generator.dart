import 'package:assosnation_app/pages/authentication.dart';
import 'package:assosnation_app/pages/detail/association_apply_form.dart';
import 'package:assosnation_app/pages/detail/association_conversation_page.dart';
import 'package:assosnation_app/pages/detail/association_details.dart';
import 'package:assosnation_app/pages/detail/user_conversation_page.dart';
import 'package:assosnation_app/services/models/association.dart';
import 'package:assosnation_app/services/models/conversation.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Authentication());
      case "/applyAssociation":
        return MaterialPageRoute(builder: (_) => AssociationApplyForm());
      case "/convAsUser":
        if (args is Conversation) {
          return MaterialPageRoute(
              builder: (_) => UserConvPage(
                    conversation: args,
                  ));
        }
        return _errorRoute();
      case "/convAsAssociation":
        if (args is Conversation) {
          return MaterialPageRoute(
              builder: (_) => AssociationConvPage(
                    conversation: args,
                  ));
        }
        return _errorRoute();
      case "/associationDetails":
        if (args is Association) {
          return MaterialPageRoute(
              builder: (context) => AssociationDetails(args));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("Error"),
        ),
      );
    });
  }
}
