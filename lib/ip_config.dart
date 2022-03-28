import 'package:controller/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IpConfigScreen extends StatefulWidget {
  const IpConfigScreen({Key? key}) : super(key: key);

  @override
  State<IpConfigScreen> createState() => _IpConfigScreenState();
}

class _IpConfigScreenState extends State<IpConfigScreen> {
  // ignore: non_constant_identifier_names
  TextEditingController hostip_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController port_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    hostip_controller.text = "192.168.0.105";
    port_controller.text = "9090";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black, Colors.grey])),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .3,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Master Node IP configuration",
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Host Ip Address",
                              style: GoogleFonts.robotoCondensed(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 3,
                          ),
                          Form(
                              child: TextFormField(
                            //initialValue: "hello",
                            controller: hostip_controller,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              fillColor: Colors.black,
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Web-Socket Port",
                            style: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Form(
                              child: TextFormField(
                            controller: port_controller,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              fillColor: Colors.white,
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 75,
              decoration: BoxDecoration(
                
                color: Colors.red[500],
                
                borderRadius: BorderRadius.circular(12),
                
              ),
              child: TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HomePage();
                }));},child: Text("Connect", style: GoogleFonts.lora(fontWeight: FontWeight.bold,color: Colors.black),),),
            )
          ],
        ),
      ),
    );
  }
}
