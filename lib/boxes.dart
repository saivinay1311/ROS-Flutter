import 'package:controller/modal.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  static Box<TopicList> getTopicList() => Hive.box<TopicList>('topicList');
}
