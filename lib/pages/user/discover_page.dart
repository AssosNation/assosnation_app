import 'package:assosnation_app/components/an_title.dart';
import 'package:assosnation_app/components/association_card.dart';
import 'package:assosnation_app/pages/detail/location.dart';
import 'package:assosnation_app/services/firebase/firestore/firestore_service.dart';
import 'package:assosnation_app/services/models/association.dart';
import 'package:assosnation_app/utils/imports/commons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnTitle(AppLocalizations.of(context)!.discover_page_title),
        Flexible(
          flex: 1,
          child: FutureBuilder(
              future: FireStoreService().getAllAssociations(),
              builder: (ctx, AsyncSnapshot<List<Association>> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    case ConnectionState.done:
                      List<Association> _assosList = snapshot.data!;
                      return CarouselSlider.builder(
                        itemCount: _assosList.length,
                        itemBuilder: (ctx, index, realIdx) {
                          return AssociationCard(_assosList[index]);
                        },
                        options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            autoPlayCurve: Curves.easeInOutBack,
                            height: MediaQuery.of(context).size.height),
                      );
                    case ConnectionState.none:
                      return CircularProgressIndicator();
                    case ConnectionState.active:
                      return CircularProgressIndicator();
                  }
                }
                return Container();
              }),
        ),
        AnTitle(AppLocalizations.of(context)!.discover_page_location_label),
        Flexible(
          flex: 1,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.elliptical(15, 10),
                    right: Radius.elliptical(10, 15))),
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: FutureBuilder(
              future: FireStoreService().getAllAssociations(),
              builder: (context, AsyncSnapshot<List<Association>> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Location(assosList: snapshot.data!);
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    case ConnectionState.none:
                      return CircularProgressIndicator();
                    case ConnectionState.active:
                      return CircularProgressIndicator();
                  }
                }
                return Container();
              },
            ),
          ),
        )
      ],
    );
  }
}
