import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;

import 'package:photo_editor/app_scaffold.dart';
import 'package:photo_editor/core/provider/cache/cache_bloc.dart';
import 'package:photo_editor/core/provider/photo/photo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await path.getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  await Hive.openBox('edited-photos');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PhotoBloc()),
        BlocProvider(create: (context) => CacheBloc()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppScaffold(),
      ),
    );
  }
}
