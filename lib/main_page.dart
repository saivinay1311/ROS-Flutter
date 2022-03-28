import 'package:controller/image_viewer.dart';
import 'package:controller/map_viewer.dart';
import 'package:controller/navigationDrawer.dart';
import 'package:controller/navigation_Viewer.dart';
import 'package:controller/pid_graph_viewer.dart';
import 'package:controller/pose_publisher.dart';
import 'package:controller/ssh.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:roslib/roslib.dart';
import 'package:page_indicator/page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    //initConnection();
    return PageIndicatorContainer(
      length: 4,
      child: PageView(
        controller: _controller,
        children: const [
          NavigationViewer(),
          GraphViewer(),
          ShhViewer(),
          RosImageViewer()
        ],
      ),
    )
    ;
  }
}


