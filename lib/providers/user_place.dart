import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_featues_favapp/models/fav_place_item.dart';

class UserPlaceStateNotifier extends StateNotifier<List<FavPlaces>>{  //using providers to maintain the state of the List<FavPlaces> throughtout the app across all screens
  UserPlaceStateNotifier() : super(const []);      //initialize the list to const [] empty list as we cannot edit the list/state in memory but create a new list everytime a ele is added or removed from list/ds hence by adding const we clear that 

  //the constructor of stateNotifier class doesnt take any parameters but must be initialized by reaching out to the super class and then initializing the data that riverpod will be working with.

  void addPlace(String title, File image, PlaceLocation location){
    final newPlace = FavPlaces(title: title, image: image, location: location);

    //state.add(newPlace); //cant be done

    state = [...state, newPlace]; //existing state plus new item/ele
  }
}

final UserPlaceStateNotifierProvider = StateNotifierProvider<UserPlaceStateNotifier, List<FavPlaces>>((ref) => UserPlaceStateNotifier());