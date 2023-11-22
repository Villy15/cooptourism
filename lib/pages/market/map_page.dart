import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapSample extends StatefulWidget {
  final String address;
  const MapSample({super.key, required this.address});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: getLatLng(widget.address),
      builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GoogleMap(
              markers: {
                Marker(
                  markerId: const MarkerId('marker_1'),
                  position: snapshot.data!,
                  infoWindow: InfoWindow(
                    title: widget.address,
                  ),
                ),
              },
              circles: {
                Circle(
                  circleId: const CircleId('circle_1'),
                  center: snapshot.data!,
                  radius: 400,
                  fillColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  strokeColor: Theme.of(context).colorScheme.primary,
                  strokeWidth: 1,
                ),
              },
              mapType: MapType.normal,
              onTap: (LatLng latLng) {
                openMap(latLng);
              },
              mapToolbarEnabled: true,
              buildingsEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: snapshot.data!,
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          );
        }
      },
    );
  }

  // Open the map on url_launcher
  Future<void> openMap(LatLng latLng) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${widget.address}';

    await canLaunchUrlString(googleMapsUrl)
        ? launchUrlString(googleMapsUrl)
        : throw 'Could not open the map.';
  }

  Future<LatLng> getLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      double latitude = locations.first.latitude;
      double longitude = locations.first.longitude;

      return LatLng(latitude, longitude);
    } catch (e) {
      return const LatLng(0, 0); // return a default value in case of error
    }
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
