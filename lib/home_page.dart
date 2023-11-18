// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// class HomePage extends StatefulWidget {
//   final String url;
//   const HomePage({super.key, required this.url});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late VideoPlayerController _controller;
//   Timer? _timer;
//   bool _controlsVisible = true;
//   Future<void>? _initializeVideoPlayerFuture;
//   int? _playBackTime;
//   Map<String, String> videoUrls = {
//     '240p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
//     '360p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
//     '480p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
//     '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
//     '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
//     '1440p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
//   };
//   String selectedQuality = 'Auto';

//   //create list of playback speed options to show in bottomSheet and set default playback speed to 1.0
//   List<double> playbackSpeed = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
//   double selectedPlaybackSpeed = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     //add widgget.url to videoUrls map on first position
//     videoUrls = {'Auto': widget.url, ...videoUrls};
//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(widget.url),
//     )
//       ..setSecretKey('hDhHtnT17ObcCSioE5r075gKOBTW3T5kVhPXxXaNCZg=')
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//         _controller.play();
//       });
//     _controller.addListener(() {
//       setState(() {
//         // _playBackTime = _controller.value.position.inSeconds;
//       });
//     });

//     // Start the timer to periodically check if the player controls are visible.
//     _timer = Timer.periodic(const Duration(seconds: 5), (_) {
//       if (_controlsVisible && _controller.value.isPlaying) {
//         setState(() {
//           _controlsVisible = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MediaQuery.of(context).orientation == Orientation.portrait ? AppBar(title: const Text('Video Testing')) : null,
//       body: Column(
//         children: [
//           _controller.value.isInitialized
//               ? Container(
//                   margin: const EdgeInsets.all(0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: Stack(
//                       children: [
//                         Stack(
//                           children: [
//                             VideoPlayer(_controller),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onVerticalDragUpdate: (details) {
//                                       _showPlayerControls();
//                                       //increase/decrease volume  0.0 - 1.0
//                                       setState(() {
//                                         _controller.setVolume(_controller.value.volume - details.delta.dy / 100);
//                                       });
//                                     },
//                                     onDoubleTap: () {
//                                       setState(() {
//                                         _controller.seekTo(_controller.value.position - const Duration(seconds: 10));
//                                       });
//                                     },
//                                     onTap: () {
//                                       if (_controlsVisible) {
//                                         setState(() {
//                                           _controlsVisible = false;
//                                         });
//                                       } else {
//                                         _showPlayerControls();
//                                       }
//                                     },
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onDoubleTap: () {
//                                       setState(() {
//                                         _controller.seekTo(_controller.value.position + const Duration(seconds: 10));
//                                       });
//                                     },
//                                     onTap: () {
//                                       if (_controlsVisible) {
//                                         setState(() {
//                                           _controlsVisible = false;
//                                         });
//                                       } else {
//                                         _showPlayerControls();
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         if (_controlsVisible)
//                           Stack(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onVerticalDragUpdate: (details) {
//                                         //increase/decrease volume  0.0 - 1.0
//                                         setState(() {
//                                           _controller.setVolume(_controller.value.volume - details.delta.dy / 100);
//                                         });
//                                       },
//                                       onDoubleTap: () {
//                                         // seek video to 10 sec behind
//                                         setState(() {
//                                           _controller.seekTo(_controller.value.position - const Duration(seconds: 10));
//                                         });
//                                       },
//                                       child: Center(
//                                         child: Row(
//                                           children: [
//                                             //controller volume indicator
//                                             Padding(
//                                               padding: const EdgeInsets.symmetric(
//                                                 horizontal: 16.0,
//                                                 vertical: 40,
//                                               ),
//                                               child: Column(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.volume_up,
//                                                     color: Colors.white.withOpacity(0.6),
//                                                     size: 20,
//                                                   ),
//                                                   Expanded(
//                                                     child: RotatedBox(
//                                                       quarterTurns: -1,
//                                                       child: ClipRRect(
//                                                         borderRadius: BorderRadius.circular(10),
//                                                         child: LinearProgressIndicator(
//                                                           value: _controller.value.volume,
//                                                           valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade300),
//                                                           backgroundColor: Colors.white.withOpacity(0.3),
//                                                           minHeight: 8,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Icon(
//                                                     Icons.volume_down,
//                                                     color: Colors.white.withOpacity(0.6),
//                                                     size: 20,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _controller.value.isPlaying ? _controller.pause() : _controller.play();
//                                       });
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.black.withOpacity(0.5),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: _controller.value.isPlaying ? const Icon(Icons.pause, size: 50, color: Colors.white) : const Icon(Icons.play_arrow, size: 50, color: Colors.white),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onVerticalDragUpdate: (details) {
//                                         //increase/decrease brightness
//                                       },
//                                       onDoubleTap: () {
//                                         // seek video to 10 sec ahead
//                                         setState(() {
//                                           _controller.seekTo(_controller.value.position + const Duration(seconds: 10));
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               //on the top right corner setting icon which open popUpMenuButton to show playback speed and quality options
//                               Positioned(
//                                 top: 0,
//                                 right: 0,
//                                 child: PopupMenuButton(
//                                   color: Colors.white,
//                                   icon: const Icon(Icons.settings),
//                                   itemBuilder: (context) => [
//                                     PopupMenuItem(
//                                       value: 1,
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.speed),
//                                           const SizedBox(width: 10),
//                                           const Text('Playback Speed'),
//                                           const Spacer(),
//                                           Text('$selectedPlaybackSpeed' 'x'),
//                                           const Icon(Icons.arrow_forward_ios, size: 13)
//                                         ],
//                                       ),
//                                       //onTap show bottomSheet with playback speed options
//                                       onTap: () {
//                                         showModalBottomSheet(
//                                           context: context,
//                                           builder: (context) => SizedBox(
//                                             child: SizedBox(
//                                               width: Get.width * 0.9,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Column(
//                                                   mainAxisSize: MainAxisSize.min,
//                                                   children: [
//                                                     //add a slick line on top of bottomSheet
//                                                     Container(
//                                                       height: 5,
//                                                       width: 60,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.grey.shade300,
//                                                         borderRadius: BorderRadius.circular(10),
//                                                       ),
//                                                     ),
//                                                     ...playbackSpeed.map(
//                                                       (e) => ListTile(
//                                                         title: Text('$e' 'x'),
//                                                         tileColor: selectedPlaybackSpeed == e ? Colors.purple.shade50 : null,
//                                                         //add border radius to each tile by 30
//                                                         shape: const RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius.all(
//                                                             Radius.circular(10),
//                                                           ),
//                                                         ),
//                                                         onTap: () {
//                                                           setState(() {
//                                                             _controller.setPlaybackSpeed(e);
//                                                           });
//                                                           setState(() {
//                                                             selectedPlaybackSpeed = e;
//                                                           });
//                                                           Navigator.pop(context);
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     PopupMenuItem(
//                                       value: 2,
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.settings),
//                                           const SizedBox(width: 10),
//                                           const Text('Quality'),
//                                           const Spacer(),
//                                           Text(selectedQuality),
//                                           const Icon(Icons.arrow_forward_ios, size: 13)
//                                         ],
//                                       ),
//                                       //onTap show bottomSheet with quality options
//                                       onTap: () {
//                                         showModalBottomSheet(
//                                           shape: const RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20),
//                                             ),
//                                           ),
//                                           context: context,
//                                           builder: (context) => SizedBox(
//                                             //reduce width of bottomSheet to 90% of screen width
//                                             width: Get.width * 0.9,
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   //add a slick line on top of bottomSheet
//                                                   Container(
//                                                     height: 5,
//                                                     width: 60,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey.shade300,
//                                                       borderRadius: BorderRadius.circular(10),
//                                                     ),
//                                                   ),
//                                                   const SizedBox(height: 10),
//                                                   ...videoUrls.keys.map((e) => ListTile(
//                                                         //border radius for each tile by 30
//                                                         shape: const RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius.all(
//                                                             Radius.circular(10),
//                                                           ),
//                                                         ),
//                                                         tileColor: selectedQuality == e ? Colors.purple.shade50 : null,
//                                                         title: Text(e),
//                                                         onTap: () {
//                                                           changeVideoQuality(videoUrls[e]!);
//                                                           Navigator.pop(context);
//                                                         },
//                                                       )),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                   onSelected: (value) {
//                                     if (value == 1) {
//                                       // playback speed
//                                     } else if (value == 2) {
//                                       // quality
//                                     }
//                                   },
//                                 ),
//                               ),

//                               Positioned(
//                                 bottom: 0,
//                                 left: 0,
//                                 right: 0,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8.0),
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [Colors.black.withOpacity(0.5), Colors.transparent],
//                                       begin: Alignment.bottomCenter,
//                                       end: Alignment.topCenter,
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Slider.adaptive(
//                                           mouseCursor: MouseCursor.defer,
//                                           activeColor: Colors.red,
//                                           inactiveColor: Colors.white,
//                                           allowedInteraction: SliderInteraction.tapAndSlide,
//                                           secondaryTrackValue: _controller.value.isInitialized
//                                               ? _controller.value.buffered.isNotEmpty
//                                                   ? _controller.value.buffered.last.end.inMilliseconds / _controller.value.duration.inMilliseconds
//                                                   : 0.0
//                                               : 0.0,
//                                           value: _controller.value.isInitialized ? _controller.value.position.inMilliseconds / _controller.value.duration.inMilliseconds : 0.0,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               _controller.seekTo(Duration(milliseconds: (value * _controller.value.duration.inMilliseconds).toInt()));
//                                             });
//                                           }),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             _controller.value.position.toString().split('.')[0],
//                                             style: const TextStyle(color: Colors.white),
//                                           ),
//                                           const Spacer(),
//                                           Text(
//                                             _controller.value.duration.toString().split('.')[0],
//                                             style: const TextStyle(color: Colors.white),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                       ],
//                     ),
//                   ),
//                 )
//               : AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: Container(
//                     color: Colors.black,
//                     child: const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }

//   void changeVideoQuality(String videoPath) {
//     Duration duration = _controller.value.position;

//     print('duration : $duration : new path : $videoPath');
//     _controller.pause();

//     _controller = VideoPlayerController.networkUrl(Uri.parse(videoPath))
//       ..setSecretKey('sassasa')
//       ..initialize().then((_) async {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//         await _controller.seekTo(duration);
//         print('new duration : ${_controller.value.position}');
//         await _controller.play();
//         selectedQuality = videoUrls.keys.firstWhere((element) => videoUrls[element] == videoPath);
//         setState(() {});
//       });
//     //change selectQuality varialbe value based on selected quality
//   }

//   // Show the player controls when the user interacts with the player.
//   void _showPlayerControls() {
//     setState(() {
//       _controlsVisible = true;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//     _timer?.cancel();
//   }
// }
