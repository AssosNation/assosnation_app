import 'package:assosnation_app/services/interfaces/location_interface.dart';
import 'package:assosnation_app/services/models/association.dart';
import 'package:assosnation_app/utils/imports/commons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class LocationService implements LocationInterface {
  late bool serviceEnabled;
  late LocationPermission permission;

  final defaultPos = CameraPosition(
    target: LatLng(48.864716, 2.349014),
    zoom: 13,
  );

  late Position currentPos;

  Future askOrCheckIfLocationServiceIsOn() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    loc.Location location = loc.Location();
    if (!serviceEnabled) {
      Future.delayed(Duration(seconds: 5));
      serviceEnabled = await location.requestService();
    }
    if (serviceEnabled) return Future.value(true);
  }

  @override
  Future<CameraPosition> determinePosition() async {
    await askOrCheckIfLocationServiceIsOn();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    currentPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    return CameraPosition(
        target: LatLng(currentPos.latitude, currentPos.longitude), zoom: 11);
  }

  @override
  Future<CameraPosition> lastKnownCameraPos() async {
    await askOrCheckIfLocationServiceIsOn();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final currentPos = await Geolocator.getLastKnownPosition();

    if (currentPos == null) return defaultPos;

    return CameraPosition(
        target: LatLng(currentPos.latitude, currentPos.longitude), zoom: 11);
  }

  @override
  Future<Set<Marker>> generateMarkersList(
      List<Association> _assoslist, BuildContext context) async {
    final markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)),
        'assets/icon/logo_an_marker.png');
    final Set<Marker> markers = {};
    for (var asso in _assoslist) {
      var i = 0;
      final List<Location> position = await locationFromAddress(
          "${asso.address}, ${asso.city} ${asso.postalCode}");

      markers.add(Marker(
          flat: true,
          markerId: MarkerId(asso.name),
          icon: markerIcon,
          position: LatLng(position[i].latitude, position[i].longitude),
          infoWindow: InfoWindow(
              onTap: () => Navigator.of(context)
                  .pushNamed('/associationDetails', arguments: asso),
              title: asso.name,
              snippet: "${asso.address}, ${asso.city} ${asso.postalCode}")));
      i++;
    }
    return markers;
  }
}
