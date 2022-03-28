import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:roslib/roslib.dart';
import 'package:line_chart/charts/line-chart.widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:controller/boxes.dart';
import 'package:controller/modal.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class GraphViewer extends StatefulWidget {
  const GraphViewer({Key? key}) : super(key: key);

  @override
  _GraphViewerState createState() => _GraphViewerState();
}

List<ListData> DataPoints = [];
List<ListData> DataPointsX = [];
List<String> addedTopics = ["linear.x", "angular.z"];
List<String> definedTopics = ["linear.x"];

List<ChartSeries> series = [];

final List<TopicList> topicList = [];
List addedTopicsList = [];
late String myTopicSelection = "linear.x";
final topicNameController = TextEditingController();

class _GraphViewerState extends State<GraphViewer> {
  LineSeries<ListData, double> linearX = LineSeries(
      color: Colors.cyanAccent[700],
      name: "linear X",
      dataSource: DataPoints,
      xValueMapper: (ListData listData, _) => listData.time,
      yValueMapper: (ListData listData, _) => listData.data);

  LineSeries<ListData, double> angularZ = LineSeries(
      color: Colors.pinkAccent,
      name: "angular Z",
      dataSource: DataPointsX,
      xValueMapper: (ListData listData, _) => listData.time,
      yValueMapper: (ListData listData, _) => listData.data);
  Ros ros = Ros(url: 'ws://192.168.0.116:9090');
  late Topic chatter;
  double c_time = 0;
  bool linearx_bool = false;
  bool angularZ_bool = false;

  void resetLinearx() {
    linearx_bool = false;
    series.remove(linearX);
  }

  void resetAngularZ() {
    angularZ_bool = false;
    series.remove(angularZ);
  }

  @override
  void initState() {
    ros;
    chatter = Topic(
        ros: ros,
        name: '/robot_0/cmd_vel',
        type: "geometry_msgs/Twist",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    super.initState();
  }

  Future<void> addTopicList(String name, String msgType) async {
    final topic = TopicList();
    topic.name = name;
    topic.msgType = msgType;
    final box = Boxes.getTopicList();
    box.add(topic);
    print("added");
  }

  void deleteTopicList(TopicList data) {
    data.delete();
  }

  Future getOpenbox(String boxname) async {
    if (!Hive.isBoxOpen(boxname)) {
      return await Hive.openBox(boxname);
    }

    return null;
  }

  // @override
  // void dispose() {
  //   Hive.close();
  //   super.dispose();
  // }

  void initConnection() async {
    ros.connect();
    await chatter.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await chatter.unsubscribe();
    await ros.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (linearx_bool == true) {
      series.add(linearX);
    }
    if (angularZ_bool == true) {
      series.add(angularZ);
    }
    var topicdatalist_g;

    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black, Colors.grey])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
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
                        color: Colors.white, fontSize: 25)),
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
              stream: ros.statusStream,
              builder: (context, snapshot) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        StreamBuilder(
                            stream: chatter.subscription,
                            builder: (context, data) {
                              if (data.hasData) {
                                if (data.data != null) {
                                  List c_data = [];
                                  List ang_z = [];

                                  c_data.add((((data.data as Map)['msg']
                                      as Map)['linear'] as Map)['x']);
                                  c_data.add(c_time);

                                  /////////

                                  ang_z.add((((data.data as Map)['msg']
                                      as Map)['angular'] as Map)['z']);
                                  ang_z.add(c_time);

                                  //////////

                                  ListData modaldata =
                                      ListData(c_data[0], c_data[1]);
                                  ListData angData =
                                      ListData(ang_z[0], ang_z[1]);

                                  ///////

                                  if (DataPoints.length <= 50) {
                                    DataPoints.add(modaldata);
                                  } else {
                                    DataPoints.removeAt(0);
                                  }
                                  if (DataPointsX.length <= 50) {
                                    DataPointsX.add(angData);
                                  } else {
                                    DataPointsX.removeAt(0);
                                  }
                                  // DataPoints.add(modaldata);
                                  // DataPointsX.add(angData);

                                  c_time += 0.1;

                                  return Column(
                                    children: [
                                      ValueListenableBuilder<Box<TopicList>>(
                                        valueListenable:
                                            Boxes.getTopicList().listenable(),
                                        builder: (context, box, _) {
                                          final topiclistData = box.values
                                              .toList()
                                              .cast<TopicList>();
                                          topicdatalist_g = topiclistData;
                                          return Column(
                                            children: [
                                              buildContent(topiclistData),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // LineChart(
                                      //     width: 500,
                                      //     height: 200,
                                      //     data: DataPoints,
                                      //     linePaint: linepaint),
                                      // snapshot.data == Status.CONNECTED
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: SfCartesianChart(
                                            enableAxisAnimation: true,
                                            plotAreaBorderWidth: 0,
                                            legend: Legend(
                                              position: LegendPosition.bottom,
                                              alignment: ChartAlignment.center,
                                              isVisible: true,
                                              borderWidth: 2,
                                            ),
                                            series: series),
                                      ),
                                      // : SfCartesianChart(plotAreaBorderWidth: 0,),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                }
                              }
                              return Container(
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
                                  ));
                            }),
                        Column(
                          children: [
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            IconButton(
                                onPressed: () {
                                  if (snapshot.data != Status.CONNECTED) {
                                    linearx_bool = false;
                                    angularZ_bool = false;
                                    initConnection();
                                  } else {
                                    linearx_bool = false;
                                    angularZ_bool = false;
                                    destroyConnection();
                                  }
                                },
                                icon: snapshot.data == Status.CONNECTED
                                    ? const Icon(Icons.pause)
                                    : const Icon(Icons.play_arrow)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    ));
  }

  Widget buildContent(List<TopicList> topiclistData) {
    // if (topiclistData.isEmpty) {
    //   return const Center(
    //     child: Text('no data'),
    //   );
    // } else {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(22)),
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton(
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange[800],
                          ),
                          icon: const Icon(
                            Icons.arrow_downward_outlined,
                            color: Colors.white,
                          ),
                          value: myTopicSelection,
                          items: topiclistData.map((items) {
                            return DropdownMenuItem(
                              value: items.name,
                              child: Text(items.name),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              myTopicSelection = newValue.toString();
                              addedTopicsList.add(newValue.toString());
                              if (myTopicSelection == "linear.x") {
                                linearx_bool = true;
                                angularZ_bool = false;
                              } else if (myTopicSelection == 'angular.z') {
                                angularZ_bool = true;
                                linearx_bool = false;
                              }

                              print(topiclistData[0].name);
                            });
                          },
                        ),
                        FittedBox(
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: ((context, setState) {
                                        return Dialog(
                                          elevation: 16,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Container(
                                            height: 500,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                  const Text(
                                                    "Custom add Topic",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        topicNameController,
                                                    decoration: const InputDecoration(
                                                        hintText:
                                                            'Enter Topic Name',
                                                        border:
                                                            OutlineInputBorder()),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        addTopicList(
                                                            topicNameController
                                                                .text,
                                                            "Bool");
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text("Add"))
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            iconSize: 29,
                          ),
                        ),
                        FittedBox(
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: ((context, setState) {
                                        return Dialog(
                                          elevation: 16,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Container(
                                            height: 500,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                  const Text(
                                                    "Delete Topics",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: topiclistData
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return ListTile(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      deleteTopicList(
                                                                          topiclistData[
                                                                              index]);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    });
                                                                  },
                                                                  leading: Text(
                                                                      topiclistData[
                                                                              index]
                                                                          .name),
                                                                  trailing:
                                                                      const Icon(
                                                                          Icons
                                                                              .delete_forever_outlined));
                                                            },
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  });
                            },
                            icon: Icon(Icons.delete,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: ((context, setState) {
                                        return Dialog(
                                          elevation: 16,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Container(
                                            height: 500,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                  const Text(
                                                    "Added Topics",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Expanded(
                                                    child: addedTopicsList
                                                            .isEmpty
                                                        ? const Center(
                                                            child: Text(
                                                                "No Topics Added"),
                                                          )
                                                        : ListView.builder(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount:
                                                                addedTopicsList
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                                  return ListTile(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          if (addedTopicsList[index] ==
                                                                              'linear.x') {
                                                                            linearx_bool =
                                                                                false;

                                                                            print("======== Deleting ========");
                                                                            series.remove(linearX);
                                                                          }
                                                                          if (addedTopicsList[index] ==
                                                                              'angular.z') {
                                                                            resetAngularZ();
                                                                          }

                                                                          print(
                                                                              addedTopicsList[index]);
                                                                        });
                                                                        addedTopicsList
                                                                            .removeAt(index);

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      leading: Text(
                                                                          addedTopicsList[
                                                                              index]),
                                                                      trailing:
                                                                          const Icon(
                                                                        Icons
                                                                            .delete_outline_outlined,
                                                                      ));
                                                                },
                                                              );
                                                            }),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          series.clear();
                                                          addedTopicsList
                                                              .clear();
                                                        });
                                                      },
                                                      child: Text(
                                                          "Reset Topics Adder")),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.list,
                              size: 30,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//}

class ListData {
  final double data;
  final double time;

  ListData(this.data, this.time);
}
