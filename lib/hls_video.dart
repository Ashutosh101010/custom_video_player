import 'dart:io';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:m3u_nullsafe/m3u_nullsafe.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class HLSVideo extends StatefulWidget {
  const HLSVideo({super.key});

  @override
  State<HLSVideo> createState() => _HLSVideoState();
}

class _HLSVideoState extends State<HLSVideo> {
  // Create a [Player] to control playback.
  late final player = Player(configuration: const PlayerConfiguration());
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player, configuration: const VideoControllerConfiguration());
  double sliderValue = 0;
  double maxValue = 1;
  bool statePlay = true;
  bool breakLoop = false;
  int index = 0;
  late HlsMediaPlaylist playList;

  List<String> urls = [];
  String base = 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/';

  Future<void> downloadVideo() async {
    try {
      File videoFile = File('sampleVideo.mp4');

      if (!videoFile.existsSync()) {
        videoFile.createSync();
      } else {
        videoFile.deleteSync();
        videoFile.createSync();
      }
      innerloop:
      for (var i = index; i <= urls.length; i++) {
        if (breakLoop) break innerloop;

        var res = await http.get(Uri.parse(base + urls[i]));
        if (res.statusCode == 200) {
          videoFile.writeAsBytesSync(res.bodyBytes, mode: FileMode.append);

          if (i == index) player.open(Media(videoFile.path));
          if (statePlay) player.play();
          print('File Downloaded Successfully : $i');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  int getSegmentIndex(int microSeconds) {
    int temp = 0;
    for (var i = 0; i < playList.segments.length; i++) {
      temp += playList.segments[i].durationUs ?? 0;
      if (microSeconds - temp <= playList.segments[i].durationUs!) {
        setState(() {
          sliderValue = temp / 1000000;
        });
        return i;
      }
    }

    return 0;
  }

  Future<void> hlsParser() async {
    File file = File('sample.m3u8');

    var res = await http.get(Uri.parse('https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/tears-of-steel-audio_eng=128002-video_eng=2200000.m3u8'));
    file.writeAsBytesSync(res.bodyBytes);
    String content = file.readAsStringSync();

    playList = await HlsPlaylistParser.create()
            .parseString(Uri.parse('https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/tears-of-steel-audio_eng=128002-video_eng=2200000.m3u8'), content)
        as HlsMediaPlaylist;

    maxValue = playList.durationUs! / 1000000;
    //micro sec to sec
    print(playList.durationUs! / 1000000);
    setState(() {});
    for (var i = 0; i < playList.segments.length; i++) {
      if (playList.segments[i].url != null) urls.add(playList.segments[i].url!);
    }
    print(urls.length);
  }

  @override
  void initState() {
    player.platform?.stream.position.listen((event) {
      setState(() {
        sliderValue = event.inMilliseconds / 1000;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();

    super.dispose();
  }

  void playerSeek(double sec) async {
    setState(() {
      statePlay = false;
      breakLoop = true;
      index = getSegmentIndex((sec * 1000000).toInt());
    });
    print('segment index : $index');
    await downloadVideo();
    setState(() {
      statePlay = true;
      breakLoop = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Back'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: downloadVideo,
              child: const Text('Download'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: hlsParser,
              child: const Text('Parser'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('seek 12 Sec'),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Video(
                controller: controller,
                controls: (state) {
                  return Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const Spacer(),
                        Slider.adaptive(
                          value: sliderValue,
                          max: maxValue,
                          onChanged: (value) {
                            print('on change at : $value');
                            playerSeek(value);
                            setState(() {
                              sliderValue = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$sliderValue'),
                            // IconButton(onPressed: (){}, icon: Icons.play_arrow_rounded).
                            Text('$maxValue'),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
