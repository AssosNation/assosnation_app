import 'dart:async';

import 'package:assosnation_app/services/location_service.dart';
import 'package:assosnation_app/services/models/association.dart';
import 'package:assosnation_app/utils/imports/commons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();

  final List<Association> assosList;

  Location({required this.assosList});
}

class _LocationState extends State<Location> {
  Completer<GoogleMapController> _controller = Completer();
  late Set<Marker> markers;

  @override
  void initState() {
    LocationService()
        .generateMarkersList(widget.assosList, context)
        .then((value) => markers = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LocationService().lastKnownCameraPos(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GoogleMap(
                initialCameraPosition: LocationService().defaultPos,
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                onMapCreated: (controller) {
                  _controller.complete(controller);
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(snapshot.data));
                },
                buildingsEnabled: false,
              );
              ;
            } else
              return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.92,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.location_service_off,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
