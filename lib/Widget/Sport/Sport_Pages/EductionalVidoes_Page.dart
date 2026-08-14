import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../Conist.dart';

class ExerciseTutorialScreen extends StatefulWidget {
  final String exerciseName;
  final String difficulty;
  final String duration;
  final String calories;

  const ExerciseTutorialScreen({
    super.key,
    required this.exerciseName,
    required this.difficulty,
    required this.duration,
    required this.calories,
  });

  @override
  State<ExerciseTutorialScreen> createState() => _ExerciseTutorialScreenState();
}

class _ExerciseTutorialScreenState extends State<ExerciseTutorialScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  int _currentStep = 0;
  bool _isPlaying = false;

  final List<Map<String, String>> steps = [
    {
      'title': 'وضعية البداية',
      'description': 'قف مع مباعدة قدميك بعرض الكتفين وذراعيك على جانبيك.',
      'duration': '0:15'
    },
    {
      'title': 'النزول',
      'description': 'اخفض جسمك عن طريق ثني الركبتين مع الحفاظ على استقامة الظهر.',
      'duration': '0:30'
    },
    {
      'title': 'حافظ على الوضعية',
      'description': 'ابقَ في وضعية القرفصاء مع جعل الفخذين موازيين للأرض.',
      'duration': '0:15'
    },
    {
      'title': 'العودة للأعلى',
      'description': 'ارفع جسمك ببطء إلى وضعية البداية.',
      'duration': '0:30'
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.asset('assets/exercise_demo.mp4');

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      aspectRatio: 16 / 9,
      placeholder: Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.fitness_center, size: 50, color: Colors.grey),
        ),
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text("تمارين رياضية", style: TextStyle(fontFamily: 'Tajawal')),
        centerTitle: true,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0,
        backgroundColor: PrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildVideoPlayer(),
            _buildExerciseInfo(),
            _buildStepProgressIndicator(),
            _buildCurrentStepCard(),
            _buildStepNavigation(),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          Chewie(controller: _chewieController),
          if (!_isPlaying)
            Center(
              child: IconButton(
                icon: const Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                    _chewieController.play();
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // Right-align for Arabic
        children: [
          Text(
            widget.exerciseName,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildInfoChip(Icons.local_fire_department, widget.calories),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.timer, widget.duration),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.star, widget.difficulty),
            ].reversed.toList(), // Reverse order for RTL
          ),
          const SizedBox(height: 16),
          const Text(
            'الوصف',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'هذا التمرين يقوي الجزء السفلي من الجسم، مع التركيز على عضلات الفخذ الرباعية وأوتار الركبة والأرداف. حافظ على الوضعية الصحيحة طوال التمرين لتجنب الإصابات.',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Tajawal',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: SecondryColor),
      label: Text(text, style: const TextStyle(fontFamily: 'Tajawal')),
      backgroundColor: Colors.white,
      side: BorderSide(color: PrimaryColor.withOpacity(0.2)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildStepProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / steps.length,
            backgroundColor: Colors.grey[200],
            color: PrimaryColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            'الخطوة ${_currentStep + 1} من ${steps.length}',
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepCard() {
    final currentStepData = steps[_currentStep];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Right-align for Arabic
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Right-align for Arabic
                children: [
                  Chip(
                    label: Text(currentStepData['duration']!),
                    backgroundColor: PrimaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: PrimaryColor, fontFamily: 'Tajawal'),
                  ),
                  const Spacer(),
                  Text(
                    currentStepData['title']!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                currentStepData['description']!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                  height: 1.5,
                ),
              ),
              if (_currentStep == 0)
                const SizedBox(height: 12),
              Text(
                'نصيحة: حافظ على شد عضلات البطن طوال التمرين لتحقيق استقرار أفضل.',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _currentStep < steps.length - 1
                ? () {
              setState(() {
                _currentStep++;
              });
            }
                : null,
            icon: const Icon(Icons.navigate_before),
            label: const Text('التالي', style: TextStyle(fontFamily: 'Tajawal')),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: PrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _currentStep > 0
                ? () {
              setState(() {
                _currentStep--;
              });
            }
                : null,
            icon: const Icon(Icons.navigate_next),
            label: const Text('السابق', style: TextStyle(fontFamily: 'Tajawal')),
            style: ElevatedButton.styleFrom(
              foregroundColor: PrimaryColor, backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: BorderSide(color: PrimaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ].reversed.toList(), // Reverse order for RTL
      ),
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          label: Text(
            _isPlaying ? 'إيقاف التمرين' : 'بدء التمرين',
            style: const TextStyle(fontSize: 18, fontFamily: 'Tajawal'),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: PrimaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            setState(() {
              _isPlaying = !_isPlaying;
              _isPlaying ? _chewieController.play() : _chewieController.pause();
            });
          },
        ),
      ),
    );
  }
}