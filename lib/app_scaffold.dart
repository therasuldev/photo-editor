import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/view/pages/edited_photos.dart';
import 'package:photo_editor/view/pages/home.dart';
import 'package:photo_editor/view/pages/photo_page.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final _pages = const [Home(), EditedPhotos()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          _currentIndex == 0 ? 'Photos' : 'Edited photos',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_album), label: 'Edited photos')
        ],
        currentIndex: _currentIndex,
        onTap: (currentIndex) => setState(() => _currentIndex = currentIndex),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: _uploadImage,
        child: const Icon(Icons.image, color: Colors.white),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      Widget builder(BuildContext context) => PhotoPage(pickedFile: pickedFile);
      Navigator.push(context, MaterialPageRoute(builder: builder));
    }
  }
}
