import 'package:flutter/material.dart';
import 'package:roslib/roslib.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:controller/pose_publisher.dart';
import 'package:http/http.dart';
import 'map_viewer.dart';

late int counter  = 0;

class HttpService {
  final call_pose1 = "http://192.168.0.116:8000/goToPose";
  final call_pose2 = "http://192.168.0.116:8000/goToPose2";
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

class NavigationViewer extends StatefulWidget {
  const NavigationViewer({Key? key}) : super(key: key);

  @override
  State<NavigationViewer> createState() => _NavigationViewerState();
}

class _NavigationViewerState extends State<NavigationViewer> {
  
  
  Ros ros = Ros(url: 'ws://192.168.0.116:9090');
  late Topic chatter;
  late Topic status;
  //late Topic status;
  @override
  void initState() {
    ros;
    chatter = Topic(
        ros: ros,
        name: '/robot_0/pose',
        type: "geometry_msgs/PoseWithCovarianceStamped",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    status = Topic(
        ros: ros,
        name: "/robot_0/execute_path/status",
        type: "actionlib_msgs/GoalStatusArray",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    super.initState();
  }

  void initConnection() async {
    ros.connect();
    await chatter.subscribe();
    await status.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await chatter.unsubscribe();
    await status.unsubscribe();
    await ros.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    HttpService service = HttpService();
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black, Colors.grey])),
            child: StreamBuilder<Object>(
              stream: ros.statusStream,
              builder: (context, snapshot) {
                return Column(
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
                                color: Colors.white, fontSize: 25),
                          ),
                          Text("GraphViewer",
                              style: GoogleFonts.robotoCondensed(
                                  color: Colors.white, fontSize: 15)),
                          Text("SSH",
                              style: GoogleFonts.robotoCondensed(
                                  color: Colors.white, fontSize: 15)),
                          Text("Teleoping",
                              style: GoogleFonts.robotoCondensed(
                                  color: Colors.white, fontSize: 15))
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: chatter.subscription,
                        builder: (context, snapshot2) {
                          
                          if (snapshot2.hasData) {
                            
                            
                            if (snapshot2.data != null) {
                              var pose = (((snapshot2.data as Map)['msg']
                                  as Map)['pose'] as Map)['pose'];
                              var x_cor =
                                  ((pose as Map)['position'] as Map)['x'];
                              var y_cor =
                                  ((pose as Map)['position'] as Map)['y'];
                              // return Text(
                              //     '${((pose as Map)['position'] as Map)['x']}');
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Stack(
                                    children: [
                                      MapViewer(y_cor, x_cor),
                                      Positioned(
                                        top: 216,
                                        left: 60,
                                        child: GestureDetector(
                                          onTap: ()async{
                                            await service.callPose1();
                                            counter = 1; 
                                          },
                                        child: Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle
                                          ),
                                        ),
                                      )),
                                      Positioned(
                                        top: 146,
                                        left: 280,
                                        child: GestureDetector(
                                          onTap: ()async{
                                            await service.callPose2();
                                            counter = 1; 
                                          },
                                        child: Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const Dialog(
                                child: Center(
                                  child: Text("Launch required"),
                                ),
                              );
                            }
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Container(
                                  height: 350,
                                  width: 350,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
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
                                  )),
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ActionChip(
                        backgroundColor: snapshot.data == Status.CONNECTED
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
                    Container(
                      alignment: Alignment.topLeft,
                      height: 200,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      child: StreamBuilder(
                          stream: status.subscription,
                          builder: (context, snapshot3) {
                            if (snapshot3.hasData) {
                              if (snapshot3.data != null) {
                                var statusdatalist = ((snapshot3.data
                                    as Map)["msg"] as Map)["status_list"];
                                    late var textdata ;

                                    if(counter>0){
                                       textdata = statusdatalist[0]["text"];
                                    }
                                    else{
                                      textdata = "Give a Goal";

                                    }
                                    

                                
                                print(statusdatalist.length);

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        "Status: ${textdata.toString()}",
                                        style: GoogleFonts.openSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Status: No data yet",
                                  style: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            );
                          }),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
