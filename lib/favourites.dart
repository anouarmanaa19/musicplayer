import 'package:flutter/material.dart';
import 'package:musicplayer/player.dart';
import 'dbhelper.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    final dbHelper = DatabaseHelper();
    favorites = await dbHelper.getFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final songName = favorites[index]['songName'];
          final songPath = favorites[index]['songPath'];
          return ListTile(
            leading: Icon(Icons.music_note),
            title: Text(songName),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Player(
                    songName: songName,
                    songPath: songPath,
                    songList: null,
                    currentIndex: 0,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
