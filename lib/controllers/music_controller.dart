import 'dart:io';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/music_model.dart';

class AudioController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer(); // Just Audio Player instance
  final audioFiles = <AudioFile>[].obs; // Observable list of audio files
  final currentFileIndex = 0.obs; // Current file index
  final isLoading = true.obs; // Loading state
  final position = Duration.zero.obs; // Current position of the audio
  final duration = Duration.zero.obs; // Total duration of the current audio

  // Cache for audio files to avoid re-fetching
  final _audioFileCache = <String, AudioFile>{};

  @override
  void onInit() {
    super.onInit();
    fetchAudioFiles();
    // Listen to audio position and duration changes
    audioPlayer.positionStream.listen((pos) => position.value = pos);
    audioPlayer.durationStream
        .listen((dur) => duration.value = dur ?? Duration.zero);

    // Listen for playback completion and play the next song automatically
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNext(); // Automatically play the next song
      }
    });
  }

  // Fetch audio files from storage with lazy loading and caching
  void fetchAudioFiles() async {
    isLoading.value = true;
    if (await Permission.storage.request().isGranted) {
      // Fetch only the required number of audio files (e.g., first 50 for display)
      audioFiles.value = await getAllAudioFiles(limit: 50);
    } else {
      print("Storage permission denied");
    }
    isLoading.value = false;
  }

  // Play an audio file by index
  void playAudio(int index) async {
    currentFileIndex.value = index;
    try {
      await audioPlayer.setFilePath(audioFiles[index].path);
      await audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Play the next audio file in the sorted list
  void playNext() {
    // Get the sorted list of audio files
    final sortedAudioFiles = List.from(audioFiles)
      ..sort((a, b) => a.title.compareTo(b.title));

    // Get the current index in the sorted list
    int currentIndexInSorted =
    sortedAudioFiles.indexOf(audioFiles[currentFileIndex.value]);

    // Calculate the next index in the sorted list
    int nextIndexInSorted =
        (currentIndexInSorted + 1) % sortedAudioFiles.length;

    // Update currentFileIndex to point to the new audio file in the original list
    currentFileIndex.value =
        audioFiles.indexOf(sortedAudioFiles[nextIndexInSorted]);

    // Play the next audio file
    playAudio(currentFileIndex.value);
  }

  void playPrevious() {
    // Get the sorted list of audio files
    final sortedAudioFiles = List.from(audioFiles)
      ..sort((a, b) => a.title.compareTo(b.title));

    // Get the current index in the sorted list
    int currentIndexInSorted =
    sortedAudioFiles.indexOf(audioFiles[currentFileIndex.value]);

    // Calculate the previous index in the sorted list
    int previousIndexInSorted =
        (currentIndexInSorted - 1 + sortedAudioFiles.length) %
            sortedAudioFiles.length;

    // Update currentFileIndex to point to the new audio file in the original list
    currentFileIndex.value =
        audioFiles.indexOf(sortedAudioFiles[previousIndexInSorted]);

    // Play the previous audio file
    playAudio(currentFileIndex.value);
  }

  // Toggle between play and pause
  void togglePlayPause() {
    audioPlayer.playing ? pause() : resume();
  }

  // Resume playback
  void resume() async {
    try {
      await audioPlayer.play();
    } catch (e) {
      print("Error resuming audio: $e");
    }
  }

  // Pause playback
  void pause() async {
    try {
      await audioPlayer.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  // Stop playback
  void stop() async {
    try {
      await audioPlayer.stop();
      position.value = Duration.zero;
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  // Seek to a specific position
  void seekTo(double value) {
    audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  // Fetch all audio files from storage with an optional limit for lazy loading
  static Future<List<AudioFile>> getAllAudioFiles({int limit = 0}) async {
    List<AudioFile> audioList = [];
    Directory internalDir = Directory('/storage/emulated/0/');
    final Directory? externalDir = await getExternalStorageDirectory();

    // Fetch files from internal and external directories
    if (await internalDir.exists())
      await _fetchAudioFiles(internalDir, audioList, limit);
    if (externalDir != null && await externalDir.exists())
      await _fetchAudioFiles(externalDir, audioList, limit);

    print("Total audio files found: ${audioList.length}");
    return audioList;
  }

  // Helper method to recursively fetch audio files from directories with a limit
  static Future<void> _fetchAudioFiles(
      Directory dir, List<AudioFile> audioList, int limit) async {
    try {
      await for (var entity in dir.list(followLinks: false)) {
        if (entity is Directory) {
          await _fetchAudioFiles(entity, audioList, limit);
        } else if (entity is File &&
            (entity.path.endsWith(".mp3") ||
                entity.path.endsWith(".wav") ||
                entity.path.endsWith(".m4a"))) {
          // Add audio file to the list and cache it
          audioList.add(AudioFile(path: entity.path, title: basename(entity.path)));

          // Check if we reached the limit
          if (limit > 0 && audioList.length >= limit) {
            break; // Exit the loop if we reached the limit
          }
        }
      }
    } catch (e) {
      print("Error fetching files from ${dir.path}: $e");
    }
  }
}
