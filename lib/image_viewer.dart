import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:roslib/roslib.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';

class RosImageViewer extends StatefulWidget {
  const RosImageViewer({Key? key}) : super(key: key);

  @override
  State<RosImageViewer> createState() => _RosImageViewerState();
}

class _RosImageViewerState extends State<RosImageViewer> {
  Ros ros = Ros(url: 'ws://192.168.0.116:9090');
  late Topic imgtopic;
  late Topic cmd_vel;

  @override
  void initState() {
    ros;
    imgtopic = Topic(
        ros: ros,
        name: '/camera/image_raw/compressed',
        type: "sensor_msgs/CompressedImage",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    cmd_vel = Topic(
        ros: ros,
        name: "cmd_vel",
        type: "geometry_msgs/Twist",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    super.initState();
  }

  void initConnection() async {
    ros.connect();
    await imgtopic.subscribe();
    await cmd_vel.advertise();
    setState(() {});
  }

  void destroyConnection() async {
    await imgtopic.unsubscribe();
    await cmd_vel.unadvertise();
    await ros.close();
    setState(() {});
  }

  void publishCmd(double linear_vel, double angular_vel) async {
    var linear = {"x": linear_vel, "y": 0, "z": 0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': angular_vel};
    var twist = {'linear': linear, 'angular': angular};
    await cmd_vel.publish(twist);
    print("cmd Published");
  }

  void move(double degrees, double distance) {
    print('Degree:' + degrees.toString() + ' Distance:' + distance.toString());
    double radians = degrees * ((22 / 7) / 180);
    double linear_speed = cos(radians) * distance;
    double angular_speed = -sin(radians) * distance;

    publishCmd(linear_speed, angular_speed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black, Colors.grey])),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(color: Colors.white),
                bottom: BorderSide(color: Colors.white),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Navigation",
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.white, fontSize: 15),
                  ),
                  Text("GraphViewer",
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.white, fontSize: 15)),
                  Text("SSH",
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.white, fontSize: 15)),
                  Text("Teleoping",
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.white, fontSize: 25))
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            StreamBuilder(
                stream: ros.statusStream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: [
                              StreamBuilder(
                                stream: imgtopic.subscription,
                                builder: (context, imgData) {
                                  if (imgData.hasData) {
                                    if (imgData.data != null) {
                                      var data = ((imgData.data as Map)['msg']
                                          as Map)["data"];
                                      var img = data[data.length - 1];
                                      // print("====${data}=====");
                                      //print(data.toString());
                                      return Column(
                                        children: [
                                          Container(
                                            height: 350,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2),
                                            ),
                                            width: 350,
                                            child: Image.memory(
                                              base64Decode(data),
                                              gaplessPlayback: true,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                  return Container(
                                      height: 350,
                                      width: 350,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text("Start the websocket Connection",
                                              style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ));
                                },
                              ),
                              ActionChip(
                                  backgroundColor:
                                      snapshot.data == Status.CONNECTED
                                          ? Colors.green[300]
                                          : Colors.red,
                                  label: Icon(Icons.power_settings_new_rounded),
                                  onPressed: () {
                                    if (snapshot.data != Status.CONNECTED) {
                                      this.initConnection();
                                    } else {
                                      this.destroyConnection();
                                    }
                                  }),
                            ],
                          ),

                          // IconButton(onPressed: (){
                          //    destroyConnection();
                          //    counter+=1;

                          // }, icon: Icon(Icons.power_settings_new_outlined),color: Colors.red,)
                        ],
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                shape: BoxShape.circle
              ),
              child: JoystickView(
                opacity: .5,
                size: 150,
                showArrows: false,
                onDirectionChanged: (degrees, distance) =>
                    move(degrees, distance),
              ),
            )
          ],
        ),
      ),
    );
  }
}
