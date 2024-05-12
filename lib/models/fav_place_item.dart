import 'dart:io';

import 'package:uuid/uuid.dart';



const uuid = Uuid(); //package defined out of class

class PlaceLocation{
  const PlaceLocation({required this.latitude, required this.longitude, required this.address});

  final double latitude;
  final double longitude;
  final String address; 
}


class FavPlaces{

  FavPlaces({required this.title, required this.image, required this.location, String? id}) : id = id ?? uuid.v4();  //if there is no id specified then we keep the auto-generated id

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}