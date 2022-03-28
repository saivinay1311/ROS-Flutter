import 'package:flutter/material.dart';
import 'package:roslib/roslib.dart';

class Subs extends StatefulWidget {
  const Subs({Key? key}) : super(key: key);

  @override
  State<Subs> createState() => _SubsState();
}

class _SubsState extends State<Subs> {
  Ros ros = Ros(url: 'ws://10.0.2.2:9090');
  late Topic chatter;

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
    super.initState();
  }

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
    return Scaffold(
      body: StreamBuilder<Object>(
          stream: ros.statusStream,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: chatter.subscription,
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          if (snapshot2.data != null) {
                            var pose = (((snapshot2.data as Map)['msg']
                                as Map)['pose'] as Map)['pose'];
                            // return Text(
                            //     '${((((snapshot2.data as Map<String, dynamic>)['msg'] as Map<String, dynamic>)['pose'] as Map)['pose'] as Map)['position']}');
                            return Text(
                                '${((pose as Map)['position'] as Map)['x']}');
                          } else {
                            return const Text("Data not there");
                          }
                        }
                        return const CircularProgressIndicator();
                      }),
                  ActionChip(
                      backgroundColor: snapshot.data == Status.CONNECTED
                          ? Colors.green[300]
                          : Colors.grey[300],
                      label: Text(snapshot.data == Status.CONNECTED
                          ? "Disconnect"
                          : 'Connect'),
                      onPressed: () {
                        if (snapshot.data != Status.CONNECTED) {
                          this.initConnection();
                        } else {
                          this.destroyConnection();
                        }
                      })
                ],
              ),
            );
          }),
    );
  }
}
