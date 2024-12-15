import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YouTubeDownloader(),
    );
  }
}

class YouTubeDownloader extends StatefulWidget {
  @override
  _YouTubeDownloaderState createState() => _YouTubeDownloaderState();
}

class _YouTubeDownloaderState extends State<YouTubeDownloader> {
  TextEditingController _urlController = TextEditingController();
  String _statusMessage = "";

  // Function to handle downloading
  Future<void> downloadVideo() async {
    String videoUrl = _urlController.text;

    if (videoUrl.isEmpty) {
      setState(() {
        _statusMessage = "Please enter a YouTube URL!";
      });
      return;
    }

    // Request storage permission
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;

      if (status.isDenied) {
        status = await Permission.storage.request();
        if (status.isDenied) {
          setState(() {
            _statusMessage = "Storage permission denied!";
          });
          return;
        }
      }

      if (status.isPermanentlyDenied) {
        setState(() {
          _statusMessage =
              "Storage permission permanently denied! Please enable it in settings.";
        });
        return;
      }
    }

    // Get video title (example of a simplified call to get details from a public API)
    var videoDetails = await fetchVideoDetails(videoUrl);
    if (videoDetails == null) {
      setState(() {
        _statusMessage = "Failed to fetch video details.";
      });
      return;
    }

    // Get directory to save file
    var directory = await getExternalStorageDirectory();
    if (directory == null) {
      setState(() {
        _statusMessage = "Unable to access storage!";
      });
      return;
    }

    var filePath = '${directory.path}/${videoDetails['title']}.mp4';
    var file = File(filePath);

    // Download video logic (this is just a placeholder)
    var videoUrlToDownload =
        videoDetails['url']; // You need to get the actual download URL
    var response = await http.get(Uri.parse(videoUrlToDownload!));
    await file.writeAsBytes(response.bodyBytes);

    setState(() {
      _statusMessage =
          "Video downloaded successfully: ${videoDetails['title']}";
    });
  }

  // Fetch video details from YouTube (simplified)
  Future<Map<String, String>?> fetchVideoDetails(String url) async {
    try {
      // Here, you should make a request to a YouTube video details API
      // This is just a placeholder and you should implement fetching video details
      var response = await http
          .get(Uri.parse('https://api.example.com/get_video_info?url=$url'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return {
          'title': data['title'],
          'url': data['download_url'], // Replace with actual download URL
        };
      }
    } catch (e) {
      print('Error fetching video details: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YouTube Video Downloader")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter YouTube Video URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: downloadVideo,
              child: Text("Download Video"),
            ),
            SizedBox(height: 10),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
