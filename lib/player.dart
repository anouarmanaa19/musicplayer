import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class Player extends StatefulWidget {
  String songName;
  final String? songPath;
  final List<SongModel>? songList;
  int currentIndex;

  Player({
    required this.songName,
    required this.songPath,
    required this.songList,
    required this.currentIndex,
  });

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final AudioPlayer _player = AudioPlayer();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 103, 4, 242),
        title: Text(
          widget.songName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Icon(Icons.audio_file)),
          SizedBox(height: 20),
          Text(
            widget.songName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () async {
                  if (currentIndex > 0) {
                    currentIndex--;
                    String? uri = widget.songList![currentIndex].uri;
                    await _player.setAudioSource(AudioSource.uri(
                        Uri.parse(uri!),
                        tag: MediaItem(
                            id: '${currentIndex - 1}',
                            album: "NA",
                            title: widget.songName,
                            artUri: Uri.parse(
                                'https://example.com/albumart.jpg'))));
                    await _player.play();
                    setState(() {
                      widget.currentIndex = currentIndex;
                      widget.songName = widget.songList![currentIndex].title;
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () async {
                  if (_player.playing) {
                    await _player.pause();
                  } else {
                    if (widget.songPath != null) {
                      await _player.setAudioSource(AudioSource.uri(
                          Uri.parse(widget.songPath!),
                          tag: MediaItem(
                              id: '${currentIndex}',
                              album: "NA",
                              title: widget.songName,
                              artUri: Uri.parse(
                                  'https://example.com/albumart.jpg'))));
                      await _player.play();
                    }
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () async {
                  if (currentIndex < widget.songList!.length - 1) {
                    currentIndex++;
                    String? uri = widget.songList![currentIndex].uri;
                    await _player.setAudioSource(AudioSource.uri(
                        Uri.parse(uri!),
                        tag: MediaItem(
                            id: '${currentIndex + 1}',
                            album: "NA",
                            title: widget.songName,
                            artUri: Uri.parse(
                                'https://example.com/albumart.jpg'))));
                    await _player.play();
                    setState(() {
                      widget.currentIndex = currentIndex;
                      widget.songName = widget.songList![currentIndex].title;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
