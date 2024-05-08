
import 'package:flutter/material.dart';
import 'package:native_featues_favapp/models/fav_place_item.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key, this.location = const PlaceLocation(latitude: 37.422, longitude: -122.088, address: ""),
   //required this.locationImage 
   this.isSelecting = true
   }); //initializing the maps with google office, as if user hasnt chosen a location and decides to select a map then this will be the initial value.

  final PlaceLocation location;
  //final String locationImage;
  final bool isSelecting;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick Your Location' : 'Your Location'),         //conditionally render the text based on whether the user has already selected a location or we are showing the default map.
        actions: [
          if(widget.isSelecting)
            IconButton(icon: const Icon(Icons.save), onPressed: (){

            },)
        ],
      ),

      //body: ,
    );
  }
}