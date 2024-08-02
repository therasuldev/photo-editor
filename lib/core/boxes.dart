import 'package:hive/hive.dart';

class Boxes {
  Box get photos => Hive.box('edited-photos');
}
