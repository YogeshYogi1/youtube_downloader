import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';

class Download {
  Future<void> downloadVideo(
      String youtube_link, String title, int selectedres) async {
    final result = await FlutterYoutubeDownloader.downloadVideo(
        youtube_link, title, selectedres);
  }
}

class Format {
  final int itag;
  final int resolution;

  Format({required this.itag, required this.resolution});
}
