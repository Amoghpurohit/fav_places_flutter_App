import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_featues_favapp/models/fav_place_item.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql
      .getDatabasesPath(); //points to the dir where the db could be created not at the db itself
  final db = await sql.openDatabase(
    path.join(
        dbPath, 'places.db'), //new db name places.db creating for first time
    onCreate: (db, version) {
      //executed when the db is created for the first time
      return db.execute(
          'CREATE TABLE fav_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    //version = 1;
  );
  return db;
}

class UserPlaceStateNotifier extends StateNotifier<List<FavPlaces>> {
  //using providers to maintain the state of the List<FavPlaces> throughtout the app across all screens
  UserPlaceStateNotifier()
      : super(
            const []); //initialize the list to const [] empty list as we cannot edit the list/state in memory but create a new list everytime a ele is added or removed from list/ds hence by adding const we clear that

  //the constructor of stateNotifier class doesnt take any parameters but must be initialized by reaching out to the super class and then initializing the data that riverpod will be working with.

  Future<void> loadPlaces() async {          //is used to load data in db to frontend, hence we convert the data in db to FavPlaces Object to set that as the state. (we convert the strings inn different columns to create FavPlaces object )
    final db = await _getDatabase();
    final data = await db.query(
        'fav_places'); //a list of maps where all rows are items in a list and each row is a map

    final places = data.map((row) => FavPlaces(  //row['title'] -> value of column title where title is the column name               //creating FavPlaces object
        id: row['id'] as String, 
        title: row['title'] as String,       // as per db.execute, how the columns are created in db
        image: File(row['image'] as String),   //image is of type file 
        location: PlaceLocation(
            latitude: row['lat'] as double,
            longitude: row['lng'] as double,
            address: row['address'] as String)
          )
        ).toList();

    state = places;   //update state to loaded places from db
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    //to store the user data we will use sqflite to create a local db inside phone annd can query them as well
    //but for image we already have a path where the image is stored but that could be deleted the OS to clear space, hence we need to copy this image and store it in a new file using the original path.(we will use path_provider and path packages for this).

    final appDir = await syspath
        .getApplicationDocumentsDirectory(); //user adds a image and its stored in a path returns a future

    final filename = path.basename(image.path);

    final copiedImage = await image.copy('${appDir.path}/$filename');
    final newPlace =
        FavPlaces(title: title, image: copiedImage, location: location);

    final db = await _getDatabase();

    db.insert('fav_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location
          .address, //storing/inserting the user data in teh newly created db
    });

    //state.add(newPlace); //cant be done

    state = [...state, newPlace]; //existing state plus new item/ele
  }
}

final UserPlaceStateNotifierProvider =
    StateNotifierProvider<UserPlaceStateNotifier, List<FavPlaces>>(
        (ref) => UserPlaceStateNotifier());
