// import 'dart:async';

// import 'package:roslib/roslib.dart';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
// import 'package:vector_math/vector_math.dart' show radians, Quaternion;

// var map_data;
// var img;

// class RvizMapViewer extends StatefulWidget {
//   const RvizMapViewer({Key? key}) : super(key: key);

//   @override
//   State<RvizMapViewer> createState() => _RvizMapViewerState();
// }




// class _RvizMapViewerState extends State<RvizMapViewer> {
//   Ros ros = Ros(url: 'ws://10.0.2.2:9090');
//    late Topic maptopic;
//   @override
//   void initState() {
//     ros;
//     maptopic = Topic(
//         ros: ros,
//         name: '/map',
//         type: "nav_msgs/OccupancyGrid",
//         reconnectOnClose: true,
//         queueLength: 10,
//         queueSize: 10);

//     super.initState();
//   }

//   void initConnection() async {
//     ros.connect();
//     await maptopic.subscribe();

//     setState(() {});
//   }

//   void destroyConnection() async {
//     await maptopic.unsubscribe();

//     await ros.close();
//     setState(() {});
//   }

//   Future<ui.Image> getMapAsImage(){
//     final completer = Completer<ui.Image>();
//     ui.decodeImageFromPixels(map_data.toRGBA(),map_data.info.width, map_data.info.width,  ui.PixelFormat.rgba8888,completer.complete);
//      return completer.future;
//   }

//   @override
//   Widget build(BuildContext context) {
//     late ui.Image? previousMap;
//     return Scaffold(
//       body: Center(
//         child: StreamBuilder(
//           stream: ros.statusStream,
//           builder: (context, snapshot) {
//             return Column(
//               children: [
//                 StreamBuilder(
//                     stream: maptopic.subscription,
//                     builder: (context, map_data) {
//                       if (map_data.hasData) {
//                         if (map_data != null) {
//                           var data =
//                               (((map_data.data as Map)["msg"]) as Map)["data"];
//                               map_data = data;
//                           return InteractiveViewer(maxScale: 10,
//                           child:FutureBuilder(
//                             future: getMapAsImage(),
                            
//                             builder: (context,imgData){
//                              if(imgData.data ==null){
//                                return SizedBox();

//                              }
//                              else
//                              {
                               
//                                img = imgData.data;
//                                return imgData.data;
//                              }
//                             },


//                           ),                          
//                           );
//                         }
//                       }
//                       return CircularProgressIndicator();
//                     }),
//                 ActionChip(
//                     backgroundColor: snapshot.data == Status.CONNECTED
//                         ? Colors.green[300]
//                         : Colors.red,
//                     label: Icon(Icons.power_settings_new_rounded),
//                     onPressed: () {
//                       if (snapshot.data != Status.CONNECTED) {
//                         this.initConnection();
//                       } else {
//                         this.destroyConnection();
//                       }
//                     }),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class Mapping extends StatefulWidget {
  

//   @override
//   State<Mapping> createState() => _MappingState();
// }

// class _MappingState extends State<Mapping> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:  CustomPaint(
//         painter: MapPainter(
          
//         ),
        
//       ),
      
//     );
//   }
// }

// class MapPainter extends CustomPainter{
//   @override
//   void paint(Canvas canvas,Size size){
//     // var paint1 = Paint();
//     // canvas.drawImage(img, Offset.zero, paint1);
//     canvas.save();
//     {
//       // canvas.scale(1, -1);
//       // canvas.translate(0, map.height.toDouble());

//       canvas.translate(img.width / 2, img.height / 2.5);
//       canvas.rotate(radians(180));
//       canvas.translate(-img.width / 2, -img.height / 2);
//       canvas.scale(1, -1);
//       canvas.translate(0, -img.height.toDouble());

//       canvas.save();
//       {
//         //Przesunięcie obrazu o magic number.
//         //Pozycja robota jest zaliczana jako środek przodu robota,
//         //stąd jest lekka różnica w oczekiwanym położeniu
//         canvas.translate(-6, -6);
//         canvas.drawImage(img, Offset.zero, Paint());
//       }
//       canvas.restore();
//     }


//   }
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
