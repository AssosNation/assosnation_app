import 'package:assosnation_app/pages/authentication.dart';
import 'package:assosnation_app/pages/user/calendar_page.dart';
import 'package:assosnation_app/pages/user/discover_page.dart';
import 'package:assosnation_app/pages/user/messaging_page.dart';
import 'package:assosnation_app/pages/user/news_feed_page.dart';
import 'package:assosnation_app/pages/user/profile_page.dart';
import 'package:assosnation_app/services/firebase/firestore/firestore_service.dart';
import 'package:assosnation_app/services/models/association.dart';
import 'package:assosnation_app/services/models/user.dart';
import 'package:assosnation_app/utils/association_search.dart';
import 'package:assosnation_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UserScaffold extends StatefulWidget {
  UserScaffold({Key? key}) : super(key: key);

  @override
  _UserScaffoldState createState() => _UserScaffoldState();
}

class _UserScaffoldState extends State<UserScaffold> {
  int _selectedPage = 2;

  final List<Widget> _pages = [
    NewsFeed(),
    Calendar(),
    Discover(),
    MessagingPage(),
    Profile(),
  ];

  Widget _userNavBar() {
    return BottomNavigationBar(
        currentIndex: _selectedPage,
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dynamic_feed),
              label: AppLocalizations.of(context)!.user_tab_newsfeed),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: AppLocalizations.of(context)!.user_tab_events),
          BottomNavigationBarItem(
              icon: Icon(Icons.saved_search),
              label: AppLocalizations.of(context)!.user_tab_discover),
          BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: AppLocalizations.of(context)!.user_tab_messaging),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: AppLocalizations.of(context)!.user_tab_profile)
        ],
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        });
  }

  Widget _controlAuthUser(_user) {
    if (_user != null)
      return _pages[_selectedPage];
    else
      return Authentication();
  }

  @override
  Widget build(BuildContext context) {
    final _user = context.watch<AnUser?>();

    return Scaffold(
      bottomNavigationBar: _user != null ? _userNavBar() : null,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Constants.fullHorizontalLogoPath,
          fit: BoxFit.cover,
          scale: Constants.appBarLogoScale,
        ),
        actions: [
          StreamBuilder<List<Association>>(
              stream: FireStoreService().getAllAssociations().asStream(),
              builder: (context, AsyncSnapshot<List<Association>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          final result = await showSearch(
                              context: context,
                              delegate: AssociationSearch(snapshot.data!));
                          if (result != null)
                            Navigator.of(context).pushNamed(
                                "/associationDetails",
                                arguments: result);
                        });
                  }
                }
                return Container();
              })
        ],
      ),
      body: Center(child: _controlAuthUser(_user)),
    );
  }
}
