import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Player extends StatefulWidget {
  final String songName;
  final String songPath;
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  Player({required this.songName, required this.songPath});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  Future<void> playSong(String path) async {
    if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await audioPlayer.play(path as Source);
      setState(() {
        isPlaying = true;
      });
    }
  }

  void nextSong() {
    // Code to play the next song
  }

  void previousSong() {
    // Code to play the previous song
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
          Center(
            child: Image.asset(
              '../assets/photo.png',
              width: 420,
              height: 400,
            ),
          ),
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
                icon: Image.asset(
                  '../assets/back.png',
                  width: 80,
                  height: 80,
                ),
                onPressed: previousSong,
              ),
              IconButton(
                icon: Image.asset(
                  '../assets/play.png',
                  width: 80,
                  height: 80,
                ),
                onPressed: () => playSong(widget.songPath),
              ),
              IconButton(
                icon: Image.asset(
                  '../assets/next.png',
                  width: 80,
                  height: 80,
                ),
                onPressed: nextSong,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
