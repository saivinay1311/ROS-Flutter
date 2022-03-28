import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpService {
  final call_pose1 = "http://192.168.0.106:8000/goToPose";
  final call_pose2 = "http://192.168.0.106:8000/goToPose2";
  final call_dock = "http://192.168.0.202:8000/dock";
  final call_undock = "http://192.168.0.202:8000/undock";
  final call_liftUp = "http://192.168.0.202:8000/liftUp";
  final call_lifDown = "http://192.168.0.202:8000/liftDown";

  bool get kDebugMode => false;

  //pose-1 call
  Future<dynamic> callPose1() async {
    Response res = await get(Uri.parse(call_pose1));
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print("Published the pose-1");
      }
    } else {
      throw "Unable to publish";
    }
  }

  Future<dynamic> callPose2() async {
    Response res = await get(Uri.parse(call_pose2));
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print("Published the pose-2");
      }
    }
  }

  //dock call
  Future<dynamic> calldock() async {
    Response res = await get(Uri.parse(call_dock));
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print("Published the pose-2");
      } else {
        throw "Unable to publish";
      }
    }
  }

  //undock call
  Future<dynamic> callundock() async {
    Response res = await get(Uri.parse(call_undock));
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print("Published the pose-2");
      } else {
        throw "Unable to publish";
      }
    }
  }

  //call liftUp
  Future<dynamic> callliftUp() async {
    Response res = await get(Uri.parse(call_liftUp));
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print("Published the pose-2");
      } else {
        throw "Unable to publish";
      }
    }
  }

  //call liftDown
  Future<dynamic> callliftDown() async {
    Response res = await get(Uri.parse(call_lifDown));
    if (res.statusCode == 200) {
      if (kDebugMode) {
        print("Published the pose-2");
      } else {
        throw "Unable to publish";
      }
    }
  }
}

class PosePublisher extends StatelessWidget {
  const PosePublisher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpService service = HttpService();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                    elevation: 0.3, backgroundColor: Colors.blue[200]),
                onPressed: () async {
                  await service.callPose1();
                },
                child: const Text(
                  'POSE-1',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              height: 40,
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                    elevation: 0.3, backgroundColor: Colors.blue[200]),
                onPressed: () async {
                  await service.callPose2();
                },
                child: const Text(
                  'POSE-2',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 40,
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                    elevation: 0.3, backgroundColor: Colors.blue[200]),
                onPressed: () async {
                  await service.calldock();
                },
                child: const Text(
                  'DOCK',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              height: 40,
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                    elevation: 0.3, backgroundColor: Colors.blue[200]),
                onPressed: () async {
                  await service.callundock();
                },
                child: const Text(
                  'UNDOCK',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 40,
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                    elevation: 0.3, backgroundColor: Colors.blue[200]),
                onPressed: () async {
                  await service.callliftUp();
                },
                child: const Text(
                  'Lift up',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              height: 40,
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                    elevation: 0.3, backgroundColor: Colors.blue[200]),
                onPressed: () async {
                  await service.callliftDown();
                },
                child: const Text(
                  'Lift Down',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
