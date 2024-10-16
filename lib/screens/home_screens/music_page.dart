import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/music_controller.dart';

class MusicPage extends GetView<AudioController> {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AudioController()); // Initialize AudioController

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1B1B),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Music Player",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "S_Music",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF71B77A),
                      ),
                    ),
                  ],
                ),
              ),

              // Music List Section
              Flexible(
                child: Obx(() {
                  // Check if audio files are loading
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF71B77A),
                      ),
                    );
                  }

                  // Check if the audio files list is empty
                  if (controller.audioFiles.isEmpty) {
                    return const Center(
                      child: Text(
                        "No audio files available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  // Sort the audio files list alphabetically by title
                  final sortedAudioFiles = List.from(controller.audioFiles)
                    ..sort((a, b) => a.title.compareTo(b.title));

                  return Scrollbar(
                    thumbVisibility: true,
                    thickness: 8.0,
                    radius: const Radius.circular(10),
                    child: ListView.builder(
                      itemCount: sortedAudioFiles.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final audioFile = sortedAudioFiles[index];
                        return
                          Obx(() {
                          print("shubham is always right");
                          final isSelected =
                              controller.currentFileIndex.value ==
                                  controller.audioFiles.indexOf(audioFile);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                controller.currentFileIndex.value =
                                    controller.audioFiles.indexOf(audioFile);
                                controller.playAudio(
                                    controller.currentFileIndex.value);
                                Scrollable.ensureVisible(
                                  context,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2A2A2A)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 13),
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          child: Image.network(
                                            audioFile.path,
                                            frameBuilder: (context, child, frame,
                                                wasSynchronouslyLoaded) {
                                              return frame != null
                                                  ? child
                                                  : const CircularProgressIndicator(
                                                strokeWidth: 5,
                                                color:
                                                Color(0xFF71B77A),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: const Color(0xFF71B77A),
                                                child: const Center(
                                                  child: Text("404"),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            audioFile.title,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  );
                }),
              ),

              // Music Player Section
              Obx(() => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                      child: Text(
                        controller.audioFiles.isNotEmpty &&
                            controller.currentFileIndex.value > 0 &&
                            controller.currentFileIndex.value < controller.audioFiles.length
                            ? controller.audioFiles[controller.currentFileIndex.value].title
                            : "Select a song",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Slider and Time
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            controller.position.value.toString().split('.').first,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFFE0E0E0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: const SliderThemeData(
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8, pressedElevation: 4),
                                trackHeight: 4,
                                thumbColor: Color(0xFF71B77A),
                                activeTrackColor: Color(0xFF71B77A),
                                inactiveTrackColor: Color(0xFFE0E0E0),
                              ),
                              child: Slider(
                                value: controller.audioFiles.isNotEmpty &&
                                    controller.currentFileIndex.value <
                                        controller.audioFiles.length
                                    ? controller.position.value.inSeconds.toDouble()
                                    : 0.0,
                                min: 0.0,
                                max: controller.audioFiles.isNotEmpty &&
                                    controller.currentFileIndex.value <
                                        controller.audioFiles.length
                                    ? controller.duration.value.inSeconds.toDouble()
                                    : 1.0,
                                onChanged: (value) {
                                  if (controller.audioFiles.isNotEmpty &&
                                      controller.currentFileIndex.value <
                                          controller.audioFiles.length) {
                                    controller.seekTo(value);
                                  }
                                },
                              ),
                            ),
                          ),
                          Text(
                            controller.audioFiles.isNotEmpty &&
                                controller.currentFileIndex.value <
                                    controller.audioFiles.length
                                ? controller.duration.value.toString().split('.').first
                                : "00:00",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFFE0E0E0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Play Controls
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: controller.playPrevious,
                            child: const Icon(
                              Icons.skip_previous,
                              size: 35,
                              color: Color(0xFF71B77A),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: controller.togglePlayPause,
                            child: Icon(
                              controller.audioPlayer.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 50,
                              color: controller.audioPlayer.playing ? Colors.white : const Color(0xFF71B77A),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: controller.playNext,
                            child: const Icon(
                              Icons.skip_next,
                              size: 35,
                              color: Color(0xFF71B77A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
