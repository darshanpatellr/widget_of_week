import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final List<Map<String, String>> _videos = [
    {
      "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "title": "Big Buck Bunny",
      "subtitle": "A large and lovable rabbit deals with three tiny bullies"
    },
    {
      "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "title": "Elephants Dream",
      "subtitle": "Two strange characters explore a capricious world"
    },
    {
      "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      "title": "For Bigger Blazes",
      "subtitle": "Experience the thrill of adventure"
    },
    {
      "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "title": "For Bigger Escapes",
      "subtitle": "Discover new destinations"
    },
    {
      "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      "title": "For Bigger Fun",
      "subtitle": "Make every moment count"
    },
    {
      "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
      "title": "Sintel",
      "subtitle": "A lonely young woman finds a baby dragon"
    },
  ];

  late PageController _pageController;
  final Map<int, VideoPlayerController> _controllers = {};
  final Set<int> _initializedControllers = {};

  bool _isInitializing = true;
  bool _showSubtitles = true;
  bool _isMuted = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeVideos();
  }

  Future<void> _initializeVideos() async {
    await _initializeVideoAt(0);

    if (mounted) {
      setState(() => _isInitializing = false);
      _controllers[0]?.play();
    }

    _initializeVideoAt(1);
    _initializeVideoAt(2);
  }

  Future<void> _initializeVideoAt(int index) async {
    if (index < 0 || index >= _videos.length) return;
    if (_initializedControllers.contains(index)) return;

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(_videos[index]["url"]!),
    );

    _controllers[index] = controller;

    try {
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(_isMuted ? 0.0 : 1.0);
      controller.setPlaybackSpeed(_playbackSpeed);

      if (mounted) {
        setState(() => _initializedControllers.add(index));
      }
    } catch (e) {
      debugPrint('Error initializing video $index: $e');
    }
  }

  void _preloadAdjacentVideos(int currentIndex) {
    _initializeVideoAt(currentIndex - 1);
    _initializeVideoAt(currentIndex + 1);
    _initializeVideoAt(currentIndex + 2);
    _disposeDistantVideos(currentIndex);
  }

  void _disposeDistantVideos(int currentIndex) {
    final toDispose = <int>[];
    _controllers.forEach((index, controller) {
      if ((index - currentIndex).abs() > 2) toDispose.add(index);
    });

    for (var index in toDispose) {
      _controllers[index]?.dispose();
      _controllers.remove(index);
      _initializedControllers.remove(index);
    }
  }

  void _onPageChanged(int index) {
    setState(() {});

    _controllers.forEach((i, controller) {
      if (i == index) {
        controller.play();
      } else {
        controller.pause();
      }
    });

    _preloadAdjacentVideos(index);
  }

  void _togglePlayPause(VideoPlayerController controller) {
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controllers.forEach((_, controller) {
        controller.setVolume(_isMuted ? 0.0 : 1.0);
      });
    });
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _controllers.forEach((_, controller) {
        controller.setPlaybackSpeed(speed);
      });
    });
  }

  void _showSettingsSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Video Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _showSubtitles = !_showSubtitles);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _showSubtitles ? CupertinoIcons.checkmark_alt : CupertinoIcons.circle,
                  size: 20,
                  color: CupertinoColors.activeBlue,
                ),
                const SizedBox(width: 8),
                const Text('Show Subtitles'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showSpeedSelector(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.speedometer, size: 20),
                const SizedBox(width: 8),
                Text('Playback Speed (${_playbackSpeed}x)'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showSpeedSelector(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Playback Speed'),
        actions: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
          return CupertinoActionSheetAction(
            onPressed: () {
              _changePlaybackSpeed(speed);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _playbackSpeed == speed ? CupertinoIcons.checkmark_alt : CupertinoIcons.circle,
                  size: 20,
                  color: _playbackSpeed == speed ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
                ),
                const SizedBox(width: 8),
                Text('${speed}x'),
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const CupertinoPageScaffold(
        backgroundColor: CupertinoColors.black,
        child: Center(child: CupertinoActivityIndicator(color: CupertinoColors.white,)),
      );
    }

    return Scaffold(
      backgroundColor: CupertinoColors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videos.length,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => _buildVideoPage(index),
          ),

          // Top gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CupertinoColors.black.withValues(alpha: 0.6),
                    CupertinoColors.black.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reels',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _showSettingsSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CupertinoColors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.gear_alt_fill,
                        color: CupertinoColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPage(int index) {
    final controller = _controllers[index];
    final videoData = _videos[index];

    if (controller == null || !_initializedControllers.contains(index)) {
      return Container(
        color: CupertinoColors.black,
        child: const Center(child: CupertinoActivityIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => _togglePlayPause(controller),
      child: Stack(
        children: [
          // Video player
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          ),

          // Play/Pause button
          if (!controller.value.isPlaying)
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: CupertinoColors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.play_fill,
                  color: CupertinoColors.white,
                  size: 40,
                ),
              ),
            ),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    CupertinoColors.black.withValues(alpha: 0.8),
                    CupertinoColors.black.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // Bottom content
          Positioned(
            bottom: 0,
            left: 0,
            right: 80,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Video title
                  Text(
                    videoData["title"]!,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  if (_showSubtitles)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: CupertinoColors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        videoData["subtitle"]!,
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 14,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: CupertinoColors.destructiveRed,
                        bufferedColor: CupertinoColors.systemGrey,
                        backgroundColor: CupertinoColors.systemGrey6,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right side actions
          Positioned(
            right: 12,
            bottom: 16,
            child: Column(
              children: [
                // _buildActionButton(
                //   icon: CupertinoIcons.heart_fill,
                //   label: '24.5K',
                //   color: CupertinoColors.systemRed,
                //   onPressed: () {},
                // ),
                // const SizedBox(height: 24),
                // _buildActionButton(
                //   icon: CupertinoIcons.chat_bubble_fill,
                //   label: '1.2K',
                //   onPressed: () {},
                // ),
                const SizedBox(height: 24),
                _buildActionButton(
                  icon: _isMuted ? CupertinoIcons.volume_off : CupertinoIcons.volume_up,
                  label: '',
                  onPressed: _toggleMute,
                ),
                const SizedBox(height: 24),
                // const SizedBox(height: 24),
                // _buildActionButton(
                //   icon: CupertinoIcons.square_arrow_up_fill,
                //   label: '856',
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color color = CupertinoColors.white,
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: CupertinoColors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: CupertinoColors.black,
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}