import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  final bool looping;
  final bool autoStart;

  VideoWidget({
    @required this.videoUrl,
    this.looping,
    this.autoStart = true,
    Key key,
  }) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl),
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoStart,
        loop: widget.looping
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      key: ObjectKey(DateTime.now()),
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () {
        print('Player is ready.');
      },
    );
  }
}
