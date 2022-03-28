import 'package:controller/pid_graph_viewer.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent[900],
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const GraphViewer();
                }));
              },
              child: const Text("PID Graph Viewer"),
            )
          ],
        ),
      ),
    );
  }
}
