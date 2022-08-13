import 'package:GrowBox/ControlHumidity.dart';
import 'package:GrowBox/grow_box_icons_icons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CircleProgress.dart';
import 'sizeConfig.dart';
import 'package:google_fonts/google_fonts.dart';
import 'globals.dart' as globals;

class Dashboard extends StatefulWidget {
  final String mac;
  final String user;

  Dashboard({ this.mac, this.user});

  @override
  _DashboardState createState() => new _DashboardState();
}

//Introducir mensajes, como pop ups que ayuden al usuario entender el
// funcionamiento de la app. Por ejemplo para MAC Input un mensaje
//"La MAC es el identificador de tu GB y se indica en la caja"

class _DashboardState extends State<Dashboard>
    with TickerProviderStateMixin {
  bool isLoading = false;
  DataSnapshot snap;
  DatabaseReference tryRef = FirebaseDatabase.instance.reference();
  var reference2Dashboard;
  var reference2GrowBox;
  var reference2Root;
  String path2child;
  String errorMessage;
  bool esp32NotConnected = false;
  AnimationController progressController;
  Animation<double> tempAnimation;
  Animation<double> humidityAnimation;
  Animation<double> luxAnimation;
  Animation<double> soilMoistureAnimation;
  bool watering, humidityControlOn, temperatureControlOn, lights, soil;
  double temperature = 0;
  double humidity = 0;
  double soilMoisture = 0;
  double lux = 0;
  String ESPtag;
  DataSnapshot snapShot;
  bool authorized = false;

  @override
  void initState() {
    super.initState();
    growBoxExists();
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    progressController.forward();
    reference2Root = FirebaseDatabase.instance
      .reference().child("CannaTips").once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> texts = snapshot.value['Texts'];
      int i = 0;
      texts.forEach((key, value) {
        globals.globalHintTitles[i] = key + "\n";
        globals.globalHintTexts[i] = value;
        print(globals.globalHintTitles[i]);
        print(globals.globalHintTexts[i]);
        i++;
      });
      Map<dynamic, dynamic> comments = snapshot.value['Comments'];
      i = 0;
      comments.forEach((key, value){
        globals.globalHintComments[i] = value;
        print(globals.globalHintComments[i]);
        i++;
      });
    });
  }


  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  Future<void> growBoxExists () async {
    bool userNotLogged = false;
    if(widget.mac != null) {
      reference2GrowBox = await FirebaseDatabase.instance
          .reference()
          .child("users/" + widget.mac)
          .once()
          .then((DataSnapshot snapshot) {
        try {
          String legitimateUser = snapshot.value['user'];
          if (legitimateUser == '') {
            userNotLogged = true;
            setState(() {
              authorized = true;
            });
          }
          else if (legitimateUser == widget.user) {
            setState(() {
              authorized = true;
            });
          }
        } catch (error) {
          userNotLogged = true;
        }
      });
    }
    else {
      setState(() {
        authorized = true;
      });
    }
    if( userNotLogged ) {
      reference2GrowBox = FirebaseDatabase.instance
          .reference()
          .child("users/"+widget.mac+"/user").set(widget.user);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/AutomaticWatering").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/ESPtag").set("2020-07-27 21:28:06");
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/HumidityControl").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/HumCtrlHigh").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/HumidityControlOn").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/HumidityOffHour").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/HumidityOnHour").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/TemperatureControl").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/TempCtrlHigh").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/TemperatureControlOn").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/TemperatureOffHour").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/TemperatureOnHour").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/Humidity").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/HumiditySet").set(100);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/Lights").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/Lux").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/OffHour").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/OnHour").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/Soil").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/SoilMoisture").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/SoilMoistureSet").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/Temperature").set(0);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/TemperatureSet").set(100);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/control/Water").set(false);
      reference2GrowBox = FirebaseDatabase.instance
          .reference().child("/growboxs/" + widget.user + "/dashboard/Watering").set(false);
    }
  }

  Future<DatabaseReference> stream2Dashboard () async {
    reference2Dashboard = FirebaseDatabase.instance
        .reference()
        .child("growboxs/"+widget.user);
    isLoading = true;
    try {
      await reference2Dashboard.once().then((DataSnapshot snapshot){
      ESPtag =  snapshot.value['ESPtag'];
      });
    } catch (error) {
      setState(() {
        authorized = false;
      });
    }
    return reference2Dashboard;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return
      Stack(
        children:<Widget> [
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(0.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/wallPaper3.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          authorized ? FutureBuilder(
            future: stream2Dashboard(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Align(
                  alignment: Alignment(0,0.2),
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 100,
                    width: SizeConfig.blockSizeHorizontal * 100,
                    child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                        ]
                    ),
                  ),
                );
              }
              else {
                return Container(
                  child: isLoading ?  StreamBuilder(
                    stream: snapshot.data.onValue,
                    builder: (context, AsyncSnapshot snap) {
                      if (!snap.hasData) {
                        return Align(
                          alignment: Alignment(0,0.2),
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 100,
                            width: SizeConfig.blockSizeHorizontal * 100,
                            child:Column(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Container(
                                    height: SizeConfig.blockSizeVertical * 30,
                                    width: SizeConfig.blockSizeHorizontal * 65,
                                    child: Text(" Si 5 minutos luego de encender el GrowBox, "
                                        "la pantalla no se actualiza, "
                                        "cierre sesión e intente de nuevo.", style: TextStyle(fontSize: 20, color: Colors.grey), textAlign: TextAlign.center,),
                                  )]),
                          ),
                        );
                      }
                      if (snap.hasData && !snap.hasError &&
                          snap.data.snapshot.value != null) {
                        DataSnapshot snapshot = snap.data.snapshot;

                        globals.controlData.automaticWatering = snapshot.value['control']['AutomaticWatering'];
                        globals.controlData.humCtrlHigh = snapshot.value['control']['HumCtrlHigh'];
                        globals.controlData.humidityControl = snapshot.value['control']['HumidityControl'];
                        globals.controlData.humidityOffHour = snapshot.value['control']['HumidityOffHour'].toInt();
                        globals.controlData.humidityOnHour = snapshot.value['control']['HumidityOnHour'].toInt();
                        globals.controlData.humiditySet = snapshot.value['control']['HumiditySet'].toInt();
                        globals.controlData.offHour = snapshot.value['control']['OffHour'].toInt();
                        globals.controlData.onHour = snapshot.value['control']['OnHour'].toInt();
                        globals.controlData.soilMoistureSet = snapshot.value['control']['SoilMoistureSet'].toInt();
                        globals.controlData.tempCtrlHigh = snapshot.value['control']['TempCtrlHigh'];
                        globals.controlData.temperatureControl = snapshot.value['control']['TemperatureControl'];
                        globals.controlData.temperatureOffHour = snapshot.value['control']['TemperatureOffHour'].toInt();
                        globals.controlData.temperatureOnHour = snapshot.value['control']['TemperatureOnHour'].toInt();
                        globals.controlData.temperatureSet = snapshot.value['control']['TemperatureSet'].toInt();
                        globals.controlData.water = snapshot.value['control']['Water'];
                        globals.controlData.temperature = snapshot.value['dashboard']['Temperature'].toDouble();
                        globals.controlData.humidity = snapshot.value['dashboard']['Humidity'].toDouble();
                        globals.controlData.lux = snapshot.value['dashboard']['Lux'].toDouble();
                        globals.controlData.watering = snapshot.value['dashboard']['Watering'];
                        globals.controlData.humidityControlOn = snapshot.value['dashboard']['HumidityControlOn'];
                        globals.controlData.temperatureControlOn = snapshot.value['dashboard']['TemperatureControlOn'];
                        globals.controlData.lights = snapshot.value['dashboard']['Lights'];
                        globals.controlData.soil = snapshot.value['dashboard']['Soil'];
                        globals.controlData.ESPtag = snapshot.value['dashboard']['ESPtag'];
                        globals.controlData.soilMoisture = snapshot.value['dashboard']['SoilMoisture'].toInt();
                        var nowTime = new DateTime.now();
                        print(nowTime.toString());
                        print(globals.controlData.automaticWatering);
                        print(globals.controlData.humCtrlHigh);
                        print(globals.controlData.humidityControl);
                        print(globals.controlData.humidityOffHour);
                        print(globals.controlData.humidityOnHour);
                        print(globals.controlData.humiditySet);
                        print(globals.controlData.offHour);
                        print(globals.controlData.onHour);
                        print(globals.controlData.soilMoistureSet);
                        print(globals.controlData.tempCtrlHigh);
                        print(globals.controlData.temperatureControl);
                        print(globals.controlData.temperatureOffHour);
                        print(globals.controlData.temperatureOnHour);
                        print(globals.controlData.temperatureOnHour);
                        print(globals.controlData.temperatureSet);
                        print(globals.controlData.water);
                        print(globals.controlData.temperature);
                        print(globals.controlData.humidity);
                        print(globals.controlData.lux);
                        print(globals.controlData.watering);
                        print(globals.controlData.humidityControlOn);
                        print(globals.controlData.temperatureControlOn);
                        print(globals.controlData.lights);
                        print(globals.controlData.soil);
                        print(globals.controlData.ESPtag);
                        print(globals.controlData.soilMoisture);
                        var espTime;
                        var difference;
                        if(globals.controlData.ESPtag.length>18) {
                          espTime = DateTime.parse(globals.controlData.ESPtag);
                          difference = nowTime.difference(espTime);

                          var muchTime = Duration(hours: 0,
                              minutes: 15,
                              seconds: 0);
                          if (difference > muchTime) {
                            esp32NotConnected = true;
                          }
                          else {
                            esp32NotConnected = false;
                          }
                        }
                        tempAnimation =
                        Tween<double>(begin: 0, end: globals.controlData.temperature).animate(
                            progressController)
                          ..addListener(() {
                            setState(() {});
                          });

                        humidityAnimation =
                        Tween<double>(begin: 0, end: globals.controlData.humidity).animate(
                            progressController)
                          ..addListener(() {
                            setState(() {});
                          });

                        luxAnimation =
                        Tween<double>(begin: 0, end: globals.controlData.lux).animate(
                            progressController)
                          ..addListener(() {
                            setState(() {});
                          });

                        soilMoistureAnimation =
                        Tween<double>(begin: 0, end: globals.controlData.soilMoisture.toDouble()).animate(
                            progressController)
                          ..addListener(() {
                            setState(() {});
                          });
                        }
                        return
                          Stack(
                              children: <Widget>[
                                 Align(
                                   alignment: Alignment(0,-0.3),
                                   child: Image.asset('images/isotipoGrowBox.png', scale: 3),
                                 ),
                                 Align(
                                     alignment: Alignment.topCenter,
                                     child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              CustomPaint(
                                                foregroundPainter:
                                                CircleProgress(
                                                    tempAnimation.value, true, false,
                                                    false, false),
                                                child: Container(
                                                  height: SizeConfig.blockSizeVertical * 35,
                                                  width: SizeConfig.blockSizeHorizontal * 40,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment(0, 0.2),
                                                        child: Text(
                                                            'Temperatura', style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: SizeConfig.safeBlockHorizontal*4.3)),),
                                                      Align(
                                                        alignment: Alignment(0.0, -0.1),
                                                        child: Text(
                                                          '${tempAnimation.value
                                                              .toInt()}°C',
                                                          style: TextStyle(
                                                              fontSize: SizeConfig.safeBlockHorizontal*11,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xFFBBB641)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              CustomPaint(
                                                foregroundPainter:
                                                CircleProgress(
                                                    humidityAnimation.value, false, true,
                                                    false, false),
                                                child: Container(
                                                  height: SizeConfig.blockSizeVertical * 35,
                                                  width: SizeConfig.blockSizeHorizontal * 40,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment(0, 0.2),
                                                        child: Text(
                                                            'Humedad', style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: SizeConfig.safeBlockHorizontal*4.3)),),
                                                      Align(
                                                        alignment: Alignment(0.0, -0.1),
                                                        child: Text(
                                                          '${humidityAnimation.value
                                                              .toInt()}%',
                                                          style: TextStyle(
                                                              fontSize: SizeConfig.safeBlockHorizontal*11,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xFFBBB641)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                 ),
                                Align(
                                  alignment: Alignment(0, 0.25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CustomPaint(
                                        foregroundPainter:
                                        CircleProgress(
                                            luxAnimation.value, false, false,
                                            true, false),
                                        child: Container(
                                          height: SizeConfig.blockSizeVertical * 35,
                                          width: SizeConfig.blockSizeHorizontal * 40,
                                          child: Stack(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment(0, 0.2),
                                                child: Text(
                                                    'Luminosidad', style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: SizeConfig.safeBlockHorizontal*4.3)),),
                                              Align(
                                                alignment: Alignment(0.0, -0.1),
                                                child: Text(
                                                  '${luxAnimation.value
                                                      .toInt()} lx',
                                                  style: TextStyle(
                                                      fontSize: SizeConfig.safeBlockHorizontal*8,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFFBBB641)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      CustomPaint(
                                        foregroundPainter:
                                        CircleProgress(
                                            soilMoistureAnimation.value, false, false,
                                            false, true),
                                        child: Container(
                                          height: SizeConfig.blockSizeVertical * 35,
                                          width: SizeConfig.blockSizeHorizontal * 40,
                                          child: Stack(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment(0, 0.2),
                                                child: Text(
                                                    'H. Suelo', style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: SizeConfig.safeBlockHorizontal*4.3)),),
                                              Align(
                                                alignment: Alignment(0.0, -0.1),
                                                child: Text(
                                                  '${soilMoistureAnimation.value
                                                      .toInt()}%',
                                                  style: TextStyle(
                                                      fontSize: SizeConfig.safeBlockHorizontal*11,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFFBBB641)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                 Align(
                                   alignment: Alignment(-0.25, 0.5),
                                   child: Tooltip(
                                     preferBelow: false,
                                     decoration: BoxDecoration(color: Color.fromRGBO(10, 10, 10, 0.6), borderRadius: BorderRadius.circular(10)),
                                     waitDuration: Duration(milliseconds: 250),
                                     message: globals.controlData.lights ? "Luz encendida" : "Luz apagada",
                                     textStyle: GoogleFonts.miriamLibre(color: globals.controlData.lights ? Color(0xFFBBB641) : Colors.grey),
                                     child: Icon(GrowBoxIcons.icono_lux_svg,
                                         size: SizeConfig.blockSizeHorizontal*14,
                                         color: globals.controlData.lights ? Color(0xFFBBB641) : Colors.grey),
                                   ),
                                 ),
                                       Align(
                                         alignment: Alignment(-0.5, 0.75),
                                         child: Tooltip(
                                           preferBelow: false,
                                           decoration: BoxDecoration(color: Color.fromRGBO(10, 10, 10, 0.6), borderRadius: BorderRadius.circular(10)),
                                           waitDuration: Duration(milliseconds: 250),
                                           message: globals.controlData.soil ? "Suelo húmedo" : "Suelo seco",
                                           textStyle: GoogleFonts.miriamLibre(color: globals.controlData.soil ? Color(0xFFBBB641) : Colors.grey),
                                           child: Icon(GrowBoxIcons.icono_hum__suelo_svg,
                                             size: SizeConfig.blockSizeHorizontal*13,
                                             color: globals.controlData.soil ? Color(0xFFBBB641) : Colors.grey),),
                                       ),
                                       Align(
                                         alignment: Alignment(0,0.75),
                                         child: Tooltip(
                                           preferBelow: false,
                                           decoration: BoxDecoration(color: Color.fromRGBO(10, 10, 10, 0.6), borderRadius: BorderRadius.circular(10)),
                                           waitDuration: Duration(milliseconds: 250),
                                           message: globals.controlData.watering ? "Riego encendido" : "Riego apagado",
                                           textStyle: GoogleFonts.miriamLibre(color: globals.controlData.watering ? Color(0xFFBBB641) : Colors.grey),
                                           child: Icon(GrowBoxIcons.icono_riego_svg,
                                               size: SizeConfig.blockSizeHorizontal*13,
                                               color: globals.controlData.watering ? Color(0xFFBBB641) : Colors.grey),
                                         ),
                                       ),
                                       Align(
                                         alignment: Alignment(0.25, 0.5),
                                         child: Tooltip(
                                           preferBelow: false,
                                           decoration: BoxDecoration(color: Color.fromRGBO(10, 10, 10, 0.6), borderRadius: BorderRadius.circular(10)),
                                           waitDuration: Duration(milliseconds: 250),
                                           message: globals.controlData.humidityControlOn ? "Ctrl. Hum. Encendido" : "Ctrl. Hum. Apagado",
                                           textStyle: GoogleFonts.miriamLibre(color: globals.controlData.humidityControlOn ? Color(0xFFBBB641) : Colors.grey),
                                           child: Icon(GrowBoxIcons.icono_in_svg,
                                               size: SizeConfig.blockSizeHorizontal*13,
                                               color: globals.controlData.humidityControlOn ? Color(0xFFBBB641) : Colors.grey),
                                         ),
                                       ),
                                       Align(
                                         alignment: Alignment(0.5, 0.75),
                                         child: Tooltip(
                                           preferBelow: false,
                                           decoration: BoxDecoration(color: Color.fromRGBO(10, 10, 10, 0.6), borderRadius: BorderRadius.circular(10)),
                                           waitDuration: Duration(milliseconds: 250),
                                           message: globals.controlData.temperatureControlOn ? "Ctrl. Temp. Encendido" : "Ctrl. Temp. Apagado",
                                           textStyle: GoogleFonts.miriamLibre(color: globals.controlData.temperatureControlOn ? Color(0xFFBBB641) : Colors.grey),
                                           child: Icon(GrowBoxIcons.icono_out_svg,
                                               size: SizeConfig.blockSizeHorizontal*13,
                                               color: globals.controlData.temperatureControlOn ? Color(0xFFBBB641) : Colors.grey),
                                         ),
                                       ),
                                 esp32NotConnected ? AlertDialog(
                                   elevation: 24,
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                   title: Text('GrowBox desconectado', style: TextStyle(color: Colors.amber, fontSize: 30)),
                                   content: Text('Verifique su alimentación eléctrica y conexión a Internet', style: TextStyle(color: Colors.amber, fontSize: 20)),
                                 ) : Container()

                              ]
                          );
                    },
                  ) :  Align(
                    alignment: Alignment(0,0.2),
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 100,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      child:Column(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Container(
                              height: SizeConfig.blockSizeVertical * 30,
                              width: SizeConfig.blockSizeHorizontal * 65,
                              child: Text(" Si 5 minutos luego de encender el GrowBox, "
                                  "la pantalla no se actualiza, "
                                  "cierre sesión e intente de nuevo.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                            )]),
                    ),
                  ),
                );
              }
            }) : Align(
                  alignment: Alignment(0,0.2),
                  child: Container(
                    height: 150,
                    width:250,
                    child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Container(
                            height: 75,
                            width: 250,
                            child: Text("Esta cuenta no es legítima propietaria", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                          )]),
                  ),
                ),
        ]
      );
  }
}
