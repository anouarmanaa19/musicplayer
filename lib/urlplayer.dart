import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlayfromURL extends StatefulWidget {
  const PlayfromURL({
    Key? key,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Telechargement audio en ligne',
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
            _progress != null
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      FileDownloader.downloadFile(
                          url: url.text.trim(),
                          onProgress: (name, progress) {
                            setState(() {
                              _progress = progress;
                            });
                          },
                          onDownloadCompleted: (value) {
                            PlayfromURL.showToast(msg: value);
                            setState(() {
                              _progress = null;
                            });

                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          });
                    },
                    child: const Text('Telecharger')),
          ],
        ),
      ),
    );
  }
}
