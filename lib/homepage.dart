// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:musicplayer/player.dart';
import 'package:musicplayer/urlplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';

import 'favourites.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  // ignore: unused_field
  List<SongModel>? _musicList;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _refreshMusicList();
  }

  Future<void> _refreshMusicList() async {
    List<SongModel> musicList = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    setState(() {
      _musicList = musicList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(),
                ),
              );
            },
          ),
        ],
        title: Text(
          'ServiceMusic',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 103, 4, 242),
      ),
      body: _musicList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _musicList!.isEmpty
              ? const Center(
                  child: Text("pas d'audios"),
                )
              : ListView.builder(
                  itemCount: _musicList!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text(_musicList![index].title),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Player(
                              songName: _musicList![index].title,
                              songPath: _musicList![index].uri,
                              songList: _musicList!,
                              currentIndex: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayfromURL(
                onDownloadCompleted: _refreshMusicList,
              ),
            ),
          );
        },
        child: Icon(Icons.link),
      ),
    );
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }

      setState(() {});
    }
  }
}
