import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_editor/core/provider/photo/photo_bloc.dart';
import 'package:photo_editor/view/pages/photo_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<PhotoBloc>().add(PhotoEvent.startFetchPhotos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBloc, PhotoState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final photos = state.photos;

        return GridView.builder(
          itemCount: photos.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            final photo = photos[index];
            return GestureDetector(
              onTap: () {
                builder(BuildContext context) => PhotoPage(photo: photo);
                final route = MaterialPageRoute(builder: builder);
                Navigator.push(context, route);
              },
              child: Container(
                width: 200,
                margin: const EdgeInsets.all(5.0),
                height: 200,
                decoration: const BoxDecoration(color: Colors.white70),
                child: CachedNetworkImage(
                  imageUrl: photo.url,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
