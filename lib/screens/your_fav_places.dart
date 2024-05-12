
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:native_featues_favapp/models/fav_place_item.dart';
import 'package:native_featues_favapp/providers/user_place.dart';
import 'package:native_featues_favapp/screens/add_place.dart';
import 'package:native_featues_favapp/screens/place_details.dart';

class YourPlaces extends ConsumerStatefulWidget {
  const YourPlaces({super.key});

  @override
  ConsumerState<YourPlaces> createState() => _YourPlacesState();
}

class _YourPlacesState extends ConsumerState<YourPlaces> {
  //final List<FavPlaces> favPlaces = [];    //since we have used stateNotifier and are watching the list using ref.watch(stateNotofierProvider) any change in the state is noted and updated

  // void _addPlace() async {
  //  final newPlace =    //get the popped object from previous screen in a variable and just add it to the list calling setState.
  //   await Navigator.push<FavPlaces>(context, MaterialPageRoute(builder: (context)=>const AddPlace()));

  //   if(newPlace == null){
  //     return; //no futher action required
  //   }

  //   setState(() {
  //     favPlaces.add(newPlace); //updating UI
  //   });
  // }

  void _addPlace(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddPlace()));
  }

  late Future _placesFuture;  //futures must be initialized but if we cant at that moment,we can set it to late to tell dart that a value will be provided when the build func is executed and not when the class is instantiated.

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(UserPlaceStateNotifierProvider.notifier).loadPlaces(); //initial state when the app is loaded and the state is updated inside the loadplaces func to places that we get from the database
    //whenever we use ref.read we must make sure that the functions have the updated state inncluded in them.
  }

  @override
  Widget build(BuildContext context) {

    final userPlace = ref.watch(UserPlaceStateNotifierProvider); //final list listens to changes to list and updates the UI


    Widget content = const Center(child: Text('No Places added yet, Use the + symbol to get started!', style: TextStyle(color: Colors.white),));

    if(userPlace.isNotEmpty){
      content = FutureBuilder(future: _placesFuture, builder: (context, snapshot)=> snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: userPlace.length,
        itemBuilder: (context, index)=>Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(userPlace[index].image),
            ),
            title: Text(userPlace[index].title),
            subtitle: Text(userPlace[index].location.address),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PlaceDetails(favPlaces: userPlace[index])));
            },
          ),
        )
          
      ));  
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: _addPlace,
            icon: const Icon(Icons.add))
        ],
      ),
      body: content,
    );
  }
}