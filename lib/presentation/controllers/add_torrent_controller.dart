import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/error/failures.dart';
import '../../../domain/usecases/torrent_usecases.dart';

class AddTorrentController extends GetxController {
  AddTorrentController({
    required AddTorrentFromUrl addTorrentFromUrl,
    required AddTorrentFromFile addTorrentFromFile,
  })  : _addTorrentFromUrl = addTorrentFromUrl,
        _addTorrentFromFile = addTorrentFromFile;

  final AddTorrentFromUrl _addTorrentFromUrl;
  final AddTorrentFromFile _addTorrentFromFile;

  final magnetController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxInt selectedTab = 0.obs;

  Future<void> addMagnetLink() async {
    final url = magnetController.text.trim();
    if (url.isEmpty) {
      Get.snackbar('Missing link', 'Paste a magnet link or torrent URL');
      return;
    }

    isLoading.value = true;
    try {
      await _addTorrentFromUrl(url);
      Get.back(result: true);
      Get.snackbar('Added', 'Torrent added successfully');
    } on Failure catch (e) {
      Get.snackbar('Failed to add torrent', e.message);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndAddTorrentFile() async {
    isLoading.value = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['torrent'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) {
        Get.snackbar('Error', 'Could not read torrent file');
        return;
      }

      await _addTorrentFromFile(bytes, file.name);
      Get.back(result: true);
      Get.snackbar('Added', 'Torrent file added successfully');
    } on Failure catch (e) {
      Get.snackbar('Failed to add torrent', e.message);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    magnetController.dispose();
    super.onClose();
  }
}
