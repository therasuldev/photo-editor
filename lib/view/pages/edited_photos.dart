import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_editor/core/provider/cache/cache_bloc.dart';
import 'package:photo_editor/view/pages/photo_page.dart';

class EditedPhotos extends StatefulWidget {
  const EditedPhotos({super.key});

  @override
  State<EditedPhotos> createState() => _EditedPhotosState();
}

class _EditedPhotosState extends State<EditedPhotos> {
  @override
  void initState() {
    super.initState();
    context.read<CacheBloc>().add(CacheEvent.startFetchCachedPhotos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CacheBloc, CacheState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator();
        }
        final editedPhotos = state.photos;
        return RefreshIndicator(
          onRefresh: () {
            context.read<CacheBloc>().add(CacheEvent.startFetchCachedPhotos());
            return Future.value();
          },
          child: GridView.builder(
            itemCount: editedPhotos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              final editedPhoto = editedPhotos[index];
              return GestureDetector(
                onTap: () {
                  Widget builder(BuildContext context) => PhotoPage(croppedFile: editedPhoto);
                  Navigator.push(context, MaterialPageRoute(builder: builder));
                },
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.all(5.0),
                  height: 200,
                  color: Colors.blueAccent,
                  child: Image.file(
                    File(editedPhoto),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
