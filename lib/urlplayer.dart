import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class UrlScreen extends StatefulWidget {
  @override
  _UrlScreenState createState() => _UrlScreenState();
}

class _UrlScreenState extends State<UrlScreen> {
  final AudioPlayer _player = AudioPlayer();
  TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _player.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _submitUrl() async {
    String url = _urlController.text;
    await _player.setUrl(url);
    await _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URL Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL',
              ),
            ),
            SizedBox(height: 16.0),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: _submitUrl,
            ),
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: () async {
                _player.pause();
              },
            ),
          ],
        ),
      ),
    );
  }
}
