import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musicplayer/player.dart';

class PlayfromURL extends StatefulWidget {
  final VoidCallback? onDownloadCompleted;

  const PlayfromURL({
    Key? key,
    this.onDownloadCompleted,
  }) : super(key: key);

  @override
  State<PlayfromURL> createState() => _PlayfromURLState();

  static void showToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class _PlayfromURLState extends State<PlayfromURL> {
  TextEditingController url = TextEditingController();
  double? _progress;
  String? _downloadedFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Téléchargement audio en ligne',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: url,
              decoration: const InputDecoration(label: Text('Lien')),
            ),
            const SizedBox(height: 16),
            if (_progress != null)
              CircularProgressIndicator()
            else if (_downloadedFilePath != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Player(
                        songName: 'musique telechargé',
                        songPath: _downloadedFilePath,
                        songList: null,
                        currentIndex: 0,
                      ),
                    ),
                  );
                },
                child: const Text('Lire'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  _downloadFile();
                },
                child: const Text('Télécharger'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadFile() async {
    setState(() {
      _progress = 0.0;
    });
    FileDownloader.downloadFile(
      url: url.text.trim(),
      onProgress: (name, progress) {
        setState(() {
          _progress = progress;
        });
      },
      onDownloadCompleted: (filePath) {
        PlayfromURL.showToast(msg: 'Téléchargement terminé');
        setState(() {
          _progress = null;
          _downloadedFilePath = filePath;
        });
        widget.onDownloadCompleted?.call();
      },
    );
  }
}
