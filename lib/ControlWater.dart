import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:GrowBox/grow_box_icons_icons.dart';
import 'CustomBorder.dart';
import 'sizeConfig.dart';
import 'globals.dart' as globals;


class ControlWater extends StatefulWidget {

  final String mac;
  final String user;
  const ControlWater(this.mac, this.user);

  @override
  _ControlWaterState createState() => new _ControlWaterState();

}

class _ControlWaterState extends State<ControlWater>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  final databaseReference = FirebaseDatabase.instance.reference();
  final reference2Dashboard = FirebaseDatabase.instance.reference();
  StreamController<bool> manualFanMenuController = StreamController.broadcast();
  StreamController<bool> wateringController = StreamController.broadcast();
  StreamController<bool> waterAlarm = StreamController.broadcast();
  bool showHint = false;
  List <String> hintTitles = ["Automático\n","Manual\n"] + globals.globalHintTitles;
  List <String> hintTexts = ["El riego se enciende de forma automática cuando la humedad del suelo disminuye por debajo del valor configurado. Una vez la humedad sea un 5% mayor al umbral seteado, el riego se apaga.\n",
      "El riego manual se enciende con la tecla a voluntad del usuario. Si no se apaga el switch, el riego corta a los 3 minutos\n"] + globals.globalHintTexts;
  List <String> hintComments = ["Elija la opción que considere necesaria. Ante cualquier duda no dude en contactarnos\n","Elija la opción que considere necesaria. Ante cualquier duda no dude en contactarnos\n"] + globals.globalHintComments;
  int _hintIndex = 0;
  int _hintButSize = 15;
  void _incrementHintIndex(){
    _hintIndex++;
    if(_hintIndex>=hintTexts.length)
    {
      _hintIndex=0;
    }
    setState(() {
      print(_hintIndex);
    });
  }
  void _decrementHintIndex(){
    _hintIndex--;
    if(_hintIndex<0)
    {
      _hintIndex=hintTexts.length-1;
    }
    setState(() {
      print(_hintIndex);
    });
    setState(() {
      print(_hintIndex);
    });
  }
  @override
  void initState() {
    super.initState();
    // arrowController = AnimationController(
    //     vsync: this, duration: Duration(milliseconds: 2000));
    // slideArrow =
    //     Tween<double>(begin: 0.0, end: 1.0).animate(arrowController);
    // slideArrow.addStatusListener((status) {
    //   int n = 0;
    //   if(status == AnimationStatus.completed && n<1){
    //     n++;
    //     arrowController.reverse();
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
        children:<Widget>[
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
        Stack(
          children: <Widget>[
          //SizedBox(width: SizeConfig.blockSizeHorizontal*6, height:SizeConfig.blockSizeVertical*3),
          Align(
            alignment: Alignment(-0.8,-0.6),
            child: Icon(GrowBoxIcons.icono_riego_svg,
                size: SizeConfig.blockSizeHorizontal*20,
                color: Color(0xFFBBB641)),
          ),
          Align(
            alignment: Alignment(1,-0.8),
            child: Container(
              height: SizeConfig.blockSizeVertical*10,
              width:  SizeConfig.blockSizeHorizontal*70,
              child: RaisedButton(
                elevation: 5.0,
                shape: CustomBorderRight(),
                color: globals.controlData.automaticWatering ?
                Color.fromRGBO(128, 0, 150, 1) :
                Color.fromRGBO(10,10,10, 0.6),
                child: Text(
                    "Automático",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal*5,
                        color: globals.controlData.automaticWatering ?
                          Color.fromRGBO(255,255,255, 1) :
                          Color.fromRGBO(255,255,255,0.6)
                    )
                ),
                onPressed: () {
                  setState(() {
                    globals.controlData.automaticWatering = true;
                    reference2Dashboard
                        .child("growboxs/"
                        + widget.user +
                        "/control/AutomaticWatering")
                        .set(globals.controlData.automaticWatering);
                    wateringController.add(globals.controlData.automaticWatering);
                  });
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment(1,-0.4),
            child: Container(
              height: SizeConfig.blockSizeVertical*10,
              width:  SizeConfig.blockSizeHorizontal*70,
              child: RaisedButton(
                elevation: 5.0,
                shape: CustomBorderRight(),
                color: globals.controlData.automaticWatering ?
                  Color.fromRGBO(10,10,10, 0.6) :
                  Color.fromRGBO(128, 0, 150, 1),
                child: Text(
                    "Manual",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal*5,
                        color: globals.controlData.automaticWatering ?
                        Color.fromRGBO(255,255,255,0.6) :
                        Color.fromRGBO(255,255,255, 1)
                    )
                ),
                onPressed: () {
                  setState(() {
                    globals.controlData.automaticWatering = false;
                    reference2Dashboard
                        .child("growboxs/"
                        + widget.user +
                        "/control/AutomaticWatering")
                        .set(globals.controlData.automaticWatering);
                    wateringController.add(globals.controlData.automaticWatering);
                  });
                },
              ),
            ),
          ),
          StreamBuilder(
              initialData: globals.controlData.automaticWatering,
              stream: wateringController.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (!snapshot.data) {
                  return Stack(
                      children: <Widget>[
                        Align(
                          alignment:Alignment(0,-0.1),
                          child: Container(
                            width: 70,
                            height: 20,
                            child: Switch(
                              value: globals.controlData.water,
                              activeColor: Color(0xFFBBB641),
                              onChanged: (newWaterOrder) {
                                setState(() {
                                  globals.controlData.water =
                                      newWaterOrder;
                                  reference2Dashboard
                                      .child("growboxs/"
                                      + widget.user +
                                      "/control/Water")
                                      .set(newWaterOrder);
                                  reference2Dashboard
                                      .child("growboxs/"
                                      + widget.user +
                                      "/dashboard/Watering")
                                      .set(newWaterOrder);
                                  waterAlarm.add(
                                      newWaterOrder);
                                });
                              },
                            ),
                          ),
                        ),
                        StreamBuilder(
                            initialData: globals.controlData.water,
                            stream: waterAlarm.stream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              if (snapshot.data) {
                                return Align(
                                  alignment: Alignment(0,0),
                                  child: Text(
                                      'Recuerde apagar el riego, sino se '
                                          'apagará en 3 min',
                                      style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal*4, color: Colors.grey)),
                                );
                              }
                              return Container();
                            }
                        )
                  ]);
                }
                else{
                  return
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment(0,-0.15),
                          child: Text("Mantener suelo al "
                              "${globals.controlData.soilMoistureSet}% de humedad",
                              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*5, color: Colors.grey)),
                        ),
                        Align(
                          alignment: Alignment(0,0),
                          child: Container(
                                  height:SizeConfig.blockSizeHorizontal*8,
                                  width:SizeConfig.screenWidth*0.8,
                                  child: Slider(
                                      value: globals.controlData.soilMoistureSet.toDouble(),
                                      label: globals.controlData.soilMoistureSet.toString(),
                                      min: 0,
                                      max: 100,
                                      activeColor: Color(0xFFC49A6C),
                                      onChanged: (newSet){
                                        setState(() => globals.controlData.soilMoistureSet = newSet.toInt());
                                        reference2Dashboard
                                            .child("growboxs/"
                                            +widget.user+"/control/SoilMoistureSet")
                                            .set(globals.controlData.soilMoistureSet);
                                      }
                                  ),
                          ),
                        ),
                      ]);
                }
                return Container();
              }
          ),
          SizedBox(width: SizeConfig.blockSizeHorizontal*3, height:SizeConfig.blockSizeVertical*3)
        ]),
        Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: showHint,
            child: Align(
              alignment: Alignment(0,1.1),
              child: Container(
                  height: SizeConfig.blockSizeVertical*40.0,
                  width: SizeConfig.blockSizeHorizontal*100,
                  color: Color.fromRGBO(10, 10, 10, 0.6),
                  margin: EdgeInsets.only(top: 50, bottom: 30),
                  child: Stack(
                    children: [
                      RichText(
                          text: TextSpan(
                              style:DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text:hintTitles[_hintIndex],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: SizeConfig.blockSizeHorizontal*6,
                                  ),
                                ),
                                TextSpan(
                                  text:hintTexts[_hintIndex],
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                TextSpan(
                                  text:hintComments[_hintIndex],
                                  style: TextStyle(
                                      color: Colors.amber
                                  ),
                                ),
                              ])
                      ),

                      Align(
                        alignment: Alignment(0.2,1),
                        child: Container(
                          height: SizeConfig.blockSizeHorizontal*10,
                          width: SizeConfig.blockSizeHorizontal*10,
                          child: FloatingActionButton(
                            child: Icon(Icons.arrow_forward),
                            onPressed: _incrementHintIndex,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.2,1),
                        child: Container(
                          height: SizeConfig.blockSizeHorizontal*10,
                          width: SizeConfig.blockSizeHorizontal*10,
                          child: FloatingActionButton(
                            child: Icon(Icons.arrow_back),
                            onPressed: _decrementHintIndex,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            )
        ),
        Align(
          alignment: Alignment(0,1),
          child:Container(
            height: SizeConfig.blockSizeHorizontal*_hintButSize,
            width: SizeConfig.blockSizeHorizontal*_hintButSize,
            child: FloatingActionButton(
              child: showHint ? Icon(Icons.arrow_drop_down) : Text("?", style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*10, color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: (){
                setState(() {
                  showHint = !showHint;
                  if(showHint)
                  {
                    _hintButSize = 10;
                  }
                  else
                  {
                    _hintButSize = 15;
                  }
                });
              },
            ),
          ),
        ),
    ]);
  }
}

class IndoorControl {
  bool tempCtrlHigh;
  bool humCtrlHigh;
  bool humidityControl;
  bool temperatureControl;
  int humidityOffHour;
  int humidityOnHour;
  int temperatureOffHour;
  int temperatureOnHour;
  int humidity;
  int humiditySet;
  bool automaticWatering;
  int onHour;
  int offHour;
  int temperature;
  int temperatureSet;
  int soilMoistureSet;
  bool water;
  bool watering;
}