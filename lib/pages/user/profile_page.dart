import 'package:assosnation_app/components/an_big_title.dart';
import 'package:assosnation_app/components/an_title.dart';
import 'package:assosnation_app/services/firebase/firestore/firestore_service.dart';
import 'package:assosnation_app/services/models/association.dart';
import 'package:assosnation_app/services/models/user.dart';
import 'package:assosnation_app/utils/imports/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = context.watch<AnUser?>();

    if (_user != null)
      FireStoreService().getSubscribedAssociationsByUser(_user.uid);

    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      AnBigTitle("My profile"),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            //TODO : add a Image in the DB for the user to display it here
            backgroundImage: NetworkImage(
                'https://media-exp1.licdn.com/dms/image/C5603AQEJ5TDmil5VAA/profile-displayphoto-shrink_800_800/0/1522223155450?e=1626307200&v=beta&t=qXIHutBHwCHF9gKoXPP_P6fnvgNvzmUqV5ZOeqDvEiI'),
            radius: 60,
          ),
          Column(
            children: [
              Row(children: [
                AnTitle(_user!.firstName),
                AnTitle(_user.lastName)
              ]),
              AnTitle(_user.mail)
            ],
          )
        ],
      ),
      Divider(
        thickness: 3,
        indent: 15,
        endIndent: 15,
        color: Colors.teal,
        height: 100,
      ),
      AnTitle(AppLocalizations.of(context)!.association_list_label),
      Expanded(
        child: FutureBuilder(
            future:
                FireStoreService().getSubscribedAssociationsByUser(_user.uid),
            builder: (ctx, AsyncSnapshot<List<Association>> snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    List<Association> assosList = snapshot.data!;
                    return Container(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(2),
                            itemCount: assosList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 20,
                                color: Theme.of(context).accentColor,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        "/associationDetails",
                                        arguments: assosList[index]);
                                  },
                                  title: Text(assosList[index].name),
                                  subtitle: Text(assosList[index].description),
                                ),
                              );
                            }));
                  case ConnectionState.none:
                    return CircularProgressIndicator();
                  case ConnectionState.active:
                    return CircularProgressIndicator();
                }
              }
              return Container();
            }),
      ),
      CupertinoButton(
          color: Colors.redAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  elevation: 50,
                  title: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.redAccent,
                    size: 55,
                  ),
                  content: Text(AppLocalizations.of(context)!.are_you_sure),
                  actions: [
                    CupertinoButton(
                      child: Text(AppLocalizations.of(context)!.yes),
                      onPressed: () {
                        final _auth = FirebaseAuth.instance;
                        _auth.signOut();
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text(
                        AppLocalizations.of(context)!.no,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          },
          child: Text(
            AppLocalizations.of(context)!.signoff_label,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          )),
      SizedBox(height: 20)
    ]);
  }
}
