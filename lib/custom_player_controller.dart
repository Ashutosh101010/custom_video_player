import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomPlayerController extends StatefulWidget {
  VideoPlayerController controller;
  CustomPlayerController({super.key, required this.controller});

  @override
  State<CustomPlayerController> createState() => _CustomPlayerControllerState();
}

class _CustomPlayerControllerState extends State<CustomPlayerController> {
  Future<void>? _initializeVideoPlayerFuture;
  int? _playBackTime;

  //The values that are passed when changing quality
  Duration? newCurrentPosition;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = widget.controller.initialize();
    widget.controller.addListener(() {
      setState(() {
        _playBackTime = widget.controller.value.position.inSeconds;
      });
    });
  }

  changeQuality(String url) {
    //change quality
    widget.controller.pause();
    widget.controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        widget.controller.play();
      });
    widget.controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  //increase/decrease volume  0.0 - 1.0
                  setState(() {
                    widget.controller.setVolume(widget.controller.value.volume - details.delta.dy / 100);
                  });
                },
                onDoubleTap: () {
                  // seek video to 10 sec behind
                  setState(() {
                    widget.controller.seekTo(widget.controller.value.position - const Duration(seconds: 10));
                  });
                },
                child: Center(
                  child: Row(
                    children: [
                      //controller volume indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 40,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.volume_up,
                              color: Colors.white.withOpacity(0.6),
                              size: 20,
                            ),
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: widget.controller.value.volume,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade300),
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.volume_down,
                              color: Colors.white.withOpacity(0.6),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.controller.value.isPlaying ? const Icon(Icons.pause, size: 50, color: Colors.white) : const Icon(Icons.play_arrow, size: 50, color: Colors.white),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  //increase/decrease brightness
                },
                onDoubleTap: () {
                  // seek video to 10 sec ahead
                  setState(() {
                    widget.controller.seekTo(widget.controller.value.position + const Duration(seconds: 10));
                  });
                },
              ),
            ),
          ],
        ),
        //on the top right corner setting icon which open popUpMenuButton to show playback speed and quality options
        Positioned(
          top: 0,
          right: 0,
          child: PopupMenuButton(
            color: Colors.white,
            icon: const Icon(Icons.settings),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: const Row(
                  children: [
                    Icon(Icons.speed),
                    SizedBox(width: 10),
                    Text('Playback Speed'),
                  ],
                ),
                //onTap show bottomSheet with playback speed options
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('0.5x'),
                            onTap: () {
                              setState(() {
                                widget.controller.setPlaybackSpeed(0.5);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('0.75x'),
                            onTap: () {
                              setState(() {
                                widget.controller.setPlaybackSpeed(0.75);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('1.0x'),
                            onTap: () {
                              setState(() {
                                widget.controller.setPlaybackSpeed(1.0);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('1.25x'),
                            onTap: () {
                              setState(() {
                                widget.controller.setPlaybackSpeed(1.25);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('1.5x'),
                            onTap: () {
                              setState(() {
                                widget.controller.setPlaybackSpeed(1.5);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('2.0x'),
                            onTap: () {
                              setState(() {
                                widget.controller.setPlaybackSpeed(2.0);
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                value: 2,
                child: const Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text('Quality'),
                  ],
                ),
                //onTap show bottomSheet with quality options
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Auto'),
                            onTap: () {
                              //set quality to auto
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('240p'),
                            onTap: () {
                              _getValuesAndPlay('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('360p'),
                            onTap: () {
                              //set quality to 360p
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('480p'),
                            onTap: () {
                              //set quality to 480p
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('720p'),
                            onTap: () {
                              //set quality to 720p
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('1080p'),
                            onTap: () {
                              //set quality to 1080p
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                // playback speed
              } else if (value == 2) {
                // quality
              }
            },
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: [
                Slider.adaptive(
                    mouseCursor: MouseCursor.defer,
                    activeColor: Colors.red,
                    inactiveColor: Colors.white,
                    allowedInteraction: SliderInteraction.tapAndSlide,
                    secondaryTrackValue: widget.controller.value.isInitialized
                        ? widget.controller.value.buffered.isNotEmpty
                            ? widget.controller.value.buffered.last.end.inMilliseconds / widget.controller.value.duration.inMilliseconds
                            : 0.0
                        : 0.0,
                    value: widget.controller.value.isInitialized ? widget.controller.value.position.inMilliseconds / widget.controller.value.duration.inMilliseconds : 0.0,
                    onChanged: (value) {
                      setState(() {
                        widget.controller.seekTo(Duration(milliseconds: (value * widget.controller.value.duration.inMilliseconds).toInt()));
                      });
                    }),
                Row(
                  children: [
                    Text(
                      widget.controller.value.position.toString().split('.')[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      widget.controller.value.duration.toString().split('.')[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _clearPrevious() async {
    await widget.controller.pause();
    return true;
  }

  Future<void> _initializePlay(String videoPath) async {
    widget.controller = VideoPlayerController.networkUrl(Uri.parse(videoPath));
    widget.controller.addListener(() {
      setState(() {
        _playBackTime = widget.controller.value.position.inSeconds;
      });
    });
    _initializeVideoPlayerFuture = widget.controller.initialize().then((_) {
      widget.controller.seekTo(newCurrentPosition!);
      widget.controller.play();
    });
  }

  void _getValuesAndPlay(String videoPath) {
    newCurrentPosition = widget.controller.value.position;
    log('new current position : $newCurrentPosition');
    _startPlay(videoPath);
    print(newCurrentPosition.toString());
  }

  Future<void> _startPlay(String videoPath) async {
    setState(() {
      _initializeVideoPlayerFuture = null;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _clearPrevious().then((_) {
        _initializePlay(videoPath);
      });
    });
  }
}
