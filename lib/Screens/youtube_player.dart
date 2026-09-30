import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWeb extends StatefulWidget {
  final String videoLink;
  const YoutubePlayerWeb({super.key, required this.videoLink});

  @override
  State<YoutubePlayerWeb> createState() => _YoutubePlayerWebState();
}

class _YoutubePlayerWebState extends State<YoutubePlayerWeb> {
  late YoutubePlayerController _controller;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: true,
        hideThumbnail: true,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Player'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  aspectRatio: 16 / 9, // Use a 16:9 aspect ratio for web
                  topActions: <Widget>[
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        _controller.metadata.title,
                        style: const TextStyle(
                          color: Colors.black, // Use dark color for web text
                          fontSize: 20.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _muted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.black,
                      ),
                      onPressed: _isPlayerReady
                          ? () {
                              _muted ? _controller.unMute() : _controller.mute();
                              setState(() {
                                _muted = !_muted;
                              });
                            }
                          : null,
                    ),
                  ],
                  bottomActions: <Widget>[
                    const SizedBox(width: 14.0),
                    CurrentPosition(),
                    const SizedBox(width: 8.0),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                  ],
                  progressIndicatorColor: Colors.black, // Dark theme for web
                  onReady: () {
                    setState(() {
                      _isPlayerReady = true;
                    });
                  },
                  onEnded: (data) {
                    _controller.reload();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}