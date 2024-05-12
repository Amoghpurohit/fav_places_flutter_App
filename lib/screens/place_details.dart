//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_featues_favapp/models/fav_place_item.dart';
import 'package:native_featues_favapp/screens/maps.dart';
//import 'package:native_featues_favapp/providers/user_place.dart';

class PlaceDetails extends ConsumerWidget {
  const PlaceDetails({super.key, required this.favPlaces});

  final FavPlaces favPlaces;

  String get locationImagegetter{

    final lat = favPlaces.location.latitude;
    final lng = favPlaces.location.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&key=YOUR_API_KEY';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //final locationImageWatcher = ref.watch(UserPlaceStateNotifierProvider);

    // void showMapsScreen(String locationImage){
    //   //locationImage = locationImagegetter;
    //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MapsScreen(
    //     //locationImage: locationImage,
    //     )));
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(favPlaces.title),
      ),
      body: Stack(   //1st widget is the lowermost one
        children: [
          Image.file( //image
            favPlaces.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          //location
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                // GestureDetector(
                //   onTap: (){
                //     showMapsScreen(locationImagegetter);
                //   },
                  //child: 
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MapsScreen(location: favPlaces.location,)));
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(locationImagegetter),      //we could build the image again using lat n lng.
                    ),
                  ),
                //),
                Text(favPlaces.location.address, textAlign: TextAlign.center,style: const TextStyle(color: Colors.white),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}