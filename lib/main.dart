import 'package:controller/image_viewer.dart';
import 'package:controller/ip_config.dart';
import 'package:controller/main_page.dart';
import 'package:controller/map_viewer.dart';
import 'package:controller/modal.dart';
import 'package:controller/navigation_Viewer.dart';
import 'package:controller/pid_graph_viewer.dart';

import 'package:controller/pose_sub.dart';
import 'package:controller/rviz_map.dart';
import 'package:controller/ssh.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TopicListAdapter());

  await Hive.openBox<TopicList>('topicList');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'AMR Controler', home: IpConfigScreen());
  }
}
