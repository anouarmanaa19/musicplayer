import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:musicplayer/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
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
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (item.data!.isEmpty) {
            return const Center(
              child: Text("pas d'audios"),
            );
          }

          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.music_note),
                title: Text(item.data![index].title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Player(
                          songName: item.data![index].title,
                          songPath: item.data![index].uri,
                          songList: item.data!,
                          currentIndex: index),
                    ),
                  );
                },
              );
            },
          );
        },
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
