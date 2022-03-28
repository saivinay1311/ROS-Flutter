import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'modal.g.dart';

@HiveType(typeId: 0)
class TopicList extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String msgType;
}
