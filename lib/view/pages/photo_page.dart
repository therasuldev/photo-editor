import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:photo_editor/core/model/photo.dart';
import 'package:photo_editor/core/service/cache_service.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key, this.photo, this.croppedFile, this.pickedFile});
  final Photo? photo;
  final String? croppedFile;
  final XFile? pickedFile;

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  CroppedFile? _croppedFile;
  late CacheServiceImpl _cacheService;
  ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _cacheService = CacheServiceImpl();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        actions: [
          ElevatedButton.icon(
            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
            onPressed: () async => await _saveImage(),
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton.icon(
            style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.redAccent)),
            onPressed: () async => await _cropImage(),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text('Edit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size.height * .75,
              width: size.width,
              decoration: const BoxDecoration(color: Colors.white70),
              child: _croppedFile != null
                  ? Image.file(File(_croppedFile!.path))
                  : widget.croppedFile != null
                      ? Image.file(File(widget.croppedFile!))
                      : widget.pickedFile != null
                          ? Image.file(File(widget.pickedFile!.path))
                          : widget.photo != null
                              ? CachedNetworkImage(imageUrl: widget.photo!.url, fit: BoxFit.contain)
                              : const Text('No image selected'),
            ),
            ValueListenableBuilder(
              valueListenable: loadingNotifier,
              builder: (context, isloading, child) => Positioned(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(.5)),
                  child: isloading ? const CircularProgressIndicator(color: Colors.white) : const SizedBox.shrink(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveImage() async {
    if (_croppedFile != null) {
      await _cacheService.put(_croppedFile!.path, _croppedFile!.path);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _cropImage() async {
    loadingNotifier.value = true;

    if (widget.photo != null) {
      final dio = Dio();
      final response = await dio.get(
        widget.photo!.url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final imagePath = path.join(directory.path, 'temp_image.jpg');
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(response.data);

        loadingNotifier.value = false;

        if (mounted) {
          final croppedFile = await _CroppedFile().croppedFile(imageFile, context);
          if (croppedFile != null) {
            setState(() => _croppedFile = croppedFile);
          }
        }
      }
    } else if (widget.pickedFile != null) {
      final pickedImageFile = File(widget.pickedFile!.path);
      final croppedFile = await _CroppedFile().croppedFile(pickedImageFile, context);

      if (croppedFile != null) {
        setState(() => _croppedFile = croppedFile);
      }
    } else if (widget.croppedFile != null) {
      final croppedImageFile = File(widget.croppedFile!);
      final croppedFile = await _CroppedFile().croppedFile(croppedImageFile, context);

      if (croppedFile != null) {
        setState(() => _croppedFile = croppedFile);
      }
    }

    loadingNotifier.value = false;
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}

class _CroppedFile {
  Future<CroppedFile?> croppedFile(File imageFile, BuildContext context) {
    return ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(width: 520, height: 520),
        ),
      ],
    );
  }
}
