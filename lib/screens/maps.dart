import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:native_featues_favapp/models/fav_place_item.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen(
      {super.key,
      this.location = const PlaceLocation(
          latitude: 37.422, longitude: -122.088, address: ""),
      //required this.locationImage
      this.isSelecting =
          true}); //initializing the maps with google office, as if user hasnt chosen a location and decides to select a map then this will be the initial value.

  final PlaceLocation location;
  //final String locationImage;
  final bool isSelecting;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {

  LatLng? _pickedLocationOnMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting
            ? 'Pick Your Location'
            : 'Your Location'), //conditionally render the text based on whether the user has already selected a location or we are showing the default map.
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(
                  _pickedLocationOnMap
                );
              },
            )
        ],
      ),
      body: GoogleMap(
        onTap: widget.isSelecting == false ? null : (position){                 //here we are listening to taps by user, get the position and get it stored in a global variable
          setState(() {
            _pickedLocationOnMap = position;  //update UI with location co ordinates
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        markers: (_pickedLocationOnMap == null && widget.isSelecting) ? {} : {  //markers takes set as input, if nothing has been picked then we dont need to show any markers, pass a empty set
        // and user is in selecting mode hance no markers shpuld be shown 
          Marker(
            markerId: const MarkerId('P1'),  //unique value to the selected place using markers
            position:
                // _pickedLocationOnMap!=null ? _pickedLocationOnMap! : LatLng(widget.location.latitude, widget.location.longitude),
                //OR
                _pickedLocationOnMap ?? LatLng(widget.location.latitude, widget.location.longitude),
          )        // ?? is a shorter way of using ternery operator which says if the value in front of the ?? is null then the other value is used else the first value is used
        },
      ),
    );
  }
}
