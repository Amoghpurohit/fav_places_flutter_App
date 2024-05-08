
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_featues_favapp/models/fav_place_item.dart';
//import 'package:native_featues_favapp/models/fav_place_item.dart';
import 'package:native_featues_favapp/providers/user_place.dart';
import 'package:native_featues_favapp/widgets/image_input.dart';
import 'dart:io';

import 'package:native_featues_favapp/widgets/location_input.dart';


class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {

  TextEditingController titleController = TextEditingController();

  File? _selectedImage;

  PlaceLocation? _selectedLocation;

  

  // void _savePlace(){
  //   Navigator.of(context).pop(
  //     FavPlaces(title: titleController.text)
  //   );
  // }

  void _savePlace(){
    final enteredTitle = titleController.text;
    if(enteredTitle.isEmpty){
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The Title value cannot be empty'), backgroundColor: Colors.white,)
        );
      });
    }
    if(_selectedImage == null){
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add an Image of the Place'), backgroundColor: Colors.white,));
      });
    }
    if(_selectedLocation == null){
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a location for the palce'), backgroundColor: Colors.white,));
      });
    }

    ref.read(UserPlaceStateNotifierProvider.notifier).addPlace(enteredTitle, _selectedImage!, _selectedLocation!); //here read method needs access to all the info user enters as we are reading it here and can watch it anywhere(use this data anywhere and watch for changes as well).
    
    //these variables wont be null as the null case has already been written
    //ref is provided by consumer state class and it gives us access to our providers

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();  //to free up memory
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: titleController,
              maxLength: 50,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                
                label: Text('Title', style: TextStyle(color: Colors.white),)
              ),
            ),
            const SizedBox(height: 15,),
            ImageInput(
              onPickImage: (image){
                _selectedImage = image;    //we need the image value in the parent widget
              },
            ),
            LocationInput(
              onSelectLocation: (location){
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 10,),
            ElevatedButton.icon(onPressed: _savePlace, icon: const Icon(Icons.add), label: const Text('Add Place'))
          ],
        ),
      ),
    );
  }
}