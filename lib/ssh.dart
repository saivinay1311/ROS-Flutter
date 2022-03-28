import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:ssh/ssh.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ShhViewer extends StatefulWidget {
  const ShhViewer({Key? key}) : super(key: key);

  @override
  State<ShhViewer> createState() => _ShhViewerState();
}

class _ShhViewerState extends State<ShhViewer> {
  var terminalController = TextEditingController();
  String terminalInput = "";
  String _res = "";
  var reslist = [];
  bool commadbool = false;
  Future connectSSH(String commad) async {
    
    final ssh = SSHClient(
        host: "192.168.0.110", port: 22, username: "waseem", passwordOrKey: "1");
         
    String result;
    try {
      result = await ssh.connect();
      if (result == "session_connected") {
        result = await ssh.startShell(
            ptyType: "xterm",
            callback: (dynamic res) {
              setState(() {
                _res = res;
                reslist.add(res);
                commadbool = true;
              });
            });
        if (result == "shell_started") {
          print(await ssh.writeToShell(commad));
          print(_res);
          //print(await ssh.writeToShell("cat world\n"));
          //print(_res);
          // Future.delayed(const Duration(seconds: 5), () async {
          //   return await ssh.closeShell();
          // });
        }
      }
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(8),
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
                          top: BorderSide(color:Colors.white),
                          bottom: BorderSide(color:Colors.white),
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Navigation",style: GoogleFonts.robotoCondensed(color:Colors.white,fontSize: 15),),
                          Text("GraphViewer",style: GoogleFonts.robotoCondensed(color:Colors.white,fontSize: 15)),
                          Text("SSH",style: GoogleFonts.robotoCondensed(color:Colors.white,fontSize: 25)),
                          Text("Teleoping",style: GoogleFonts.robotoCondensed(color:Colors.white,fontSize: 15))
                        ],

                      ),
                    ),
                    SizedBox(height: 30,),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .45,
                    child: TextFormField(
                      initialValue: "192.168.0.105",
                      style: GoogleFonts.roboto(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        labelText: "IP Address",
                        labelStyle: GoogleFonts.roboto(color: Colors.white),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .45,
                    child: TextFormField(
                      initialValue: "vinay",
                      style: GoogleFonts.roboto(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        labelText: "Host Name",
                        labelStyle: GoogleFonts.roboto(color: Colors.white),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .45,
                    child: TextFormField(
                      initialValue: "22",
                      style: GoogleFonts.roboto(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        labelText: "Port",
                        labelStyle: GoogleFonts.roboto(color: Colors.white),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .45,
                    child: TextFormField(
                      obscureText: true,
                      initialValue: "12234",
                      style: GoogleFonts.roboto(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        labelText: "Password",
                        labelStyle: GoogleFonts.roboto(color: Colors.white),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width,
                  child: commadbool
                      ? SingleChildScrollView(
                          child: Text(
                          reslist
                              .toString()
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                          style: GoogleFonts.roboto(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ))
                      : Container(
                          child: Center(
                            child: Text(
                              "Terminal Shell Output",
                              style: GoogleFonts.roboto(color: Colors.white),
                            ),
                          ),
                        )),
              SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Terminal Input",
                  //     style: GoogleFonts.robotoCondensed(
                  //         color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: terminalController,
                          onChanged: (value) {
                            setState(() {
                              terminalController.text = value;
                              terminalController.selection =
                                  TextSelection.collapsed(
                                      offset: terminalController.text.length);
                            });
                          },
                          style: GoogleFonts.roboto(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            labelText: "Terminal Input",
                            labelStyle: GoogleFonts.roboto(color: Colors.white),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[200], shape: BoxShape.circle),
                          child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    reslist.clear();
                                    connectSSH("${terminalController.text}\n");
                                    //rprint(terminalController.text);
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                  },
                                  icon: Icon(Icons.send))))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
