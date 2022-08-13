import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:GrowBox/grow_box_icons_icons.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'sizeConfig.dart';
import 'CustomBorder.dart';
import 'globals.dart' as globals;
import 'dart:async';


class ControlHumidity extends StatefulWidget {

  final String mac;
  final String user;
  const ControlHumidity(this.mac, this.user);

  @override
  _ControlHumidityState createState() => new _ControlHumidityState();

}

class _ControlHumidityState extends State<ControlHumidity>
    with SingleTickerProviderStateMixin {
  final databaseReference = FirebaseDatabase.instance.reference();
  final reference2Dashboard = FirebaseDatabase.instance.reference();
  StreamController<bool> manualFanMenuController = StreamController.broadcast();
  StreamController<bool> wateringController = StreamController.broadcast();
  StreamController<bool> waterAlarm = StreamController.broadcast();
  bool showHint = false;
  List <String> hintTitles = ["Control automático\n","Control periódico\n"]  + globals.globalHintTitles;
  List <String> hintTexts = ["Esta salida del GrowBox puede ser controlada por humedad, tanto si esta decrece o se eleva demasiado.\n"
      "El Ctrl. por alto, enciende la salida cuando la humedad crece por encima del valor configurado.\n El Ctrl. por bajo enciende la salida cuando la humedad decrese por debajo del valor configurado.\n","El Ctrl. Periódico, al igual que la iluminación, indica la hora en que se enciende y apaga esta salida.\n"] + globals.globalHintTexts;
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
    Color enabledColor = Colors.amber;
    Color disabledColor = Colors.grey;
    Color ctrlHighButtonColor;
    Color ctrlLowButtonColor;
    Color lowTextColor;
    Color highTextColor;
    Color disabledTextColor = Color(0xFF434343);
    Color enabledTextColor = Color(0xFFFFFFFF);

    if(globals.controlData.humCtrlHigh) {
      ctrlHighButtonColor = enabledColor;
      ctrlLowButtonColor = disabledColor;
      highTextColor = enabledTextColor ;
      lowTextColor = disabledTextColor;
    }
    else {
      ctrlHighButtonColor = disabledColor;
      ctrlLowButtonColor = enabledColor;
      highTextColor = disabledTextColor;
      lowTextColor = enabledTextColor;
    }

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
              Align(
                alignment: Alignment(-0.8,-0.7),
                child: Icon(GrowBoxIcons.icono_hum__suelo_svg,
                    size: SizeConfig.blockSizeHorizontal*24,
                    color: Color(0xFFBBB641)),
            ),
            Align(
              alignment: Alignment(1,-0.9),
              child: Container(
                height: SizeConfig.blockSizeVertical*10,
                width:  SizeConfig.blockSizeHorizontal*70,
                child: RaisedButton(
                  elevation: 5.0,
                  shape: CustomBorderRight(),
                  color: globals.controlData.humidityControl ?
                  Color.fromRGBO(128, 0, 150, 1) :
                  Color.fromRGBO(10,10,10, 0.6),
                  child: Text(
                      "Automático",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal*5,
                          color: globals.controlData.humidityControl ?
                          Color.fromRGBO(255,255,255, 1) :
                          Color.fromRGBO(255,255,255,0.6)
                      )
                  ),
                  onPressed: () {
                    setState(() {
                      globals.controlData.humidityControl = true;
                      reference2Dashboard
                          .child("growboxs/"
                          + widget.user +
                          "/control/HumidityControl")
                          .set(globals.controlData.humidityControl);
                      manualFanMenuController.add(globals.controlData.humidityControl);
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment(1,-0.5),
              child: Container(
                height: SizeConfig.blockSizeVertical*10,
                width:  SizeConfig.blockSizeHorizontal*70,
                child: RaisedButton(
                  elevation: 5.0,
                  shape: CustomBorderRight(),
                  color: globals.controlData.humidityControl ?
                  Color.fromRGBO(10,10,10, 0.6) :
                  Color.fromRGBO(128, 0, 150, 1),
                  child: Text(
                      "Periódico",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal*5,
                          color: globals.controlData.humidityControl ?
                          Color.fromRGBO(255,255,255,0.6) :
                          Color.fromRGBO(255,255,255, 1)
                      )
                  ),
                  onPressed: () {
                    setState(() {
                      globals.controlData.humidityControl = false;
                      reference2Dashboard
                          .child("growboxs/"
                          + widget.user +
                          "/control/HumidityControl")
                          .set(globals.controlData.humidityControl);
                      manualFanMenuController.add(globals.controlData.humidityControl);
                    });
                  },
                ),
              ),
            ),
            StreamBuilder(
                initialData: globals.controlData
                    .humidityControl,
                stream: manualFanMenuController.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  if (!snapshot.data) {
                    return Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment(0,0),
                          child:
                          Container(
                            height: SizeConfig.blockSizeVertical*13,
                            width:  SizeConfig.blockSizeHorizontal*100,
                            child: RaisedButton(
                                elevation: 5.0,
                                shape: CustomBorderCenter(),
                                color:  Color.fromRGBO(10, 10, 10, 0.6),
                                child: Align(
                                  alignment: Alignment(0,0),
                                  child:  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(GrowBoxIcons.icono_hum__suelo_svg,
                                            size: SizeConfig.blockSizeHorizontal*14,
                                            color: Color(0xFFBBB641)),
                                        Text('${globals.controlData.humidityOnHour
                                            .toInt()}:00hs',
                                            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*7, color: Colors.grey)),
                                        Icon(GrowBoxIcons.icono_hum__suelo_svg,
                                            size: SizeConfig.blockSizeHorizontal*14,
                                            color: Colors.grey),
                                        Text('${globals.controlData.humidityOffHour
                                            .toInt()}:00hs',
                                            style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*7, color: Colors.grey)),
                                      ]
                                  ),
                                ),
                                onPressed: () {
                                  changePeriod(context,
                                      globals.controlData.humidityOnHour.toInt(),
                                      globals.controlData.humidityOffHour.toInt()
                                  );
                                }
                            ),
                          ),
                        ),
                      ]);
                  }
                  else {
                    return
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment(0,-0.2),
                            child: Text("Control de humedad a "
                                "${globals.controlData.humiditySet}%.",
                                style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*6, color: Colors.grey)),
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*3, height:SizeConfig.blockSizeVertical),
                          Align(
                            alignment: Alignment(0,-0.05),
                            child:Container(
                              height:SizeConfig.blockSizeHorizontal*8,
                              width:SizeConfig.screenWidth*0.8,
                              child: Slider(
                                  value: globals.controlData.humiditySet.toDouble(),
                                  label: globals.controlData.humiditySet.toString(),
                                  min: 20,
                                  max: 100,
                                  activeColor: Color(0xFF9CDBEE),
                                  onChanged: (newSet){
                                    setState(() => globals.controlData.humiditySet = newSet.toInt());
                                    reference2Dashboard
                                        .child("growboxs/"
                                        +widget.user+"/control/HumiditySet")
                                        .set(globals.controlData.humiditySet);
                                  }
                              ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal*3, height:SizeConfig.blockSizeVertical),
                          Align(
                            alignment: Alignment(0,0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(  //CtrlHigh button
                                  style: ElevatedButton.styleFrom(
                                      primary:ctrlHighButtonColor
                                  ),
                                  child: Row(
                                      children: <Widget>[
                                        Text("Ctrl",style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*6, color: highTextColor)),
                                        Icon(Icons.arrow_upward, color: highTextColor)
                                      ]
                                  ),
                                  onPressed: () {
                                    setState((){
                                      globals.controlData.humCtrlHigh = true;
                                      reference2Dashboard.child("growboxs/"
                                          + widget.user + "/control/HumCtrlHigh").set(globals.controlData.humCtrlHigh);
                                      ctrlHighButtonColor = enabledColor;
                                      ctrlLowButtonColor = disabledColor;
                                      highTextColor = enabledTextColor;
                                      lowTextColor = disabledTextColor;
                                    });
                                  },
                                ),
                                ElevatedButton(  //CtrlLow button
                                  style: ElevatedButton.styleFrom(
                                      primary:ctrlLowButtonColor
                                  ),
                                  child: Row(
                                      children: <Widget>[
                                        Text("Ctrl",style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*6, color:lowTextColor)),
                                        Icon(Icons.arrow_downward, color: lowTextColor)
                                      ]
                                  ),
                                  onPressed: () {
                                    setState((){
                                      globals.controlData.humCtrlHigh = false;
                                      reference2Dashboard.child("growboxs/"
                                          + widget.user + "/control/HumCtrlHigh").set(globals.controlData.humCtrlHigh);
                                      ctrlHighButtonColor = disabledColor;
                                      ctrlLowButtonColor = enabledColor;
                                      highTextColor = disabledTextColor;
                                      lowTextColor = enabledTextColor;
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      );
                  }
                  return Container();
                }
            ),
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
        ]
    );
  }

  void _updateParent(int init, int end) {
    setState((){
        globals.controlData.humidityOnHour = init;
        globals.controlData.humidityOffHour = end;
        reference2Dashboard
            .child("growboxs/"
            +widget.user+"/control/HumidityOnHour")
            .set(init);
        Future.delayed(const Duration(milliseconds: 1000), ()
        {
          reference2Dashboard
              .child("growboxs/"
              + widget.user + "/control/HumidityOffHour")
              .set(end);
        });
    });
  }

  changePeriod(BuildContext context, int init, int end) {
    return showDialog(context: context, builder: (BuildContext context){
      return StatefulBuilder(
          builder: (context, setState) {
            void _updateLabels(int init, int end, int laps) {
              _updateParent(init, end);
              setState(() {
                  globals.controlData.humidityOnHour = init;
                  globals.controlData.humidityOffHour = end;
              });
            }
            return AlertDialog(
                backgroundColor: Colors.transparent,
                actions:<Widget>[
                  DoubleCircularSlider(
                    24,
                    init,
                    end,
                    height: 260.0,
                    width: 260.0,
                    primarySectors: 24,
                    secondarySectors: 0,
                    baseColor: Color.fromRGBO(255, 255, 255, 0.1),
                    selectionColor: Color(0xFFBBB641),
                    handlerColor: Colors.white,
                    handlerOutterRadius: 12.0,
                    onSelectionChange:_updateLabels,
                    sliderStrokeWidth: 12.0,
                    child: Padding(
                        padding: const EdgeInsets.all(42.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${_formatIntervalTime(globals.controlData.humidityOnHour.toInt(), globals.controlData.humidityOffHour.toInt())}',
                                style: TextStyle(fontSize: 36.0, color: Colors.white)),
                          ],
                        )),
                    shouldCountLaps: false,
                  ),

                ]
            );
          });
    });
  }

  String _formatIntervalTime(int init, int end) {
    var onTime = end > init ? end - init : 24 - init + end;
    return '${onTime}hs';
  }

}