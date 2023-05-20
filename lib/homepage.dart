import 'dart:io';
import 'package:musicplayer/player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class Song {
  final String name;
  final String path;

  Song({required this.name, required this.path});
}

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    final directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync();

    List<Song> loadedSongs = [];

    for (var file in files) {
      if (file.path.endsWith('.mp3')) {
        final String fileName = file.path.split('/').last;
        loadedSongs.add(
          Song(name: fileName, path: file.path),
        );
      }
    }

    setState(() {
      songs = loadedSongs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ServiceMusic',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 103, 4, 242),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ListTile(
              leading: Image.asset(
                '../assets/songicon.png',
                width: 48,
                height: 48,
              ),
              title: Text(
                song.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Player(
                      songName: song.name,
                      songPath: song.path,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
