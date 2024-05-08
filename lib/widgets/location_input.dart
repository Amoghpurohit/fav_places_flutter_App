import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:native_featues_favapp/models/fav_place_item.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedLocation; //initially the location could be false, if its not null then its of type Location

  var _isgettingLocation;

  String get locationImage {
    if (pickedLocation == null) {
      return "";
    }
    final lat = pickedLocation!.latitude;
    final lng = pickedLocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&key=YOUR_API_KEY';
  }

  void _selectLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isgettingLocation = true;
    });
    locationData = await location
        .getLocation(); //getting users location can take some time hence we are displaying a CircularProgressIndicator to give feedback to user.

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=YOUR_API_KEY');

    final response = await http.get(url);

    final data = json.decode(response.body);
    final address = data['results'][0]
        ['formatted_address']; //location in human readable form

    // print(locationData.latitude);
    // print(locationData.longitude);

    setState(() {
      pickedLocation =  PlaceLocation(      //update pickedLocation with lat, lgn.. values
          latitude: lat, longitude: lng, address: address); //for preview
      _isgettingLocation = false;
    });

    widget.onSelectLocation(pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget locationPreview = const Text(
      'No location added yet',
      textAlign: TextAlign.center,
    );

    if (_isgettingLocation) {
      locationPreview = const CircularProgressIndicator();
    }

    if(pickedLocation != null){      //if none of the latitude, longitude or the address are null then build a location image in which we are using the static maps api
      locationPreview = Image.network(locationImage, fit: BoxFit.cover, width: double.infinity,);
    }

    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
          ),
          child: locationPreview,
        ),
        Row(
          children: [
            TextButton.icon(
                onPressed: _selectLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Get Current Location')),
            TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.map),
                label: const Text('Select on Map')),
          ],
        ),
      ],
    );
  }
}
