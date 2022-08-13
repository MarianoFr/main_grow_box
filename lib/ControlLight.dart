import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:GrowBox/grow_box_icons_icons.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'sizeConfig.dart';
import 'CustomBorder.dart';
import 'globals.dart' as globals;

class ControlLight extends StatefulWidget {

  final String mac;
  final String user;
  const ControlLight(this.mac, this.user);
  @override
  _ControlLightState createState() => new _ControlLightState();

}

class _ControlLightState extends State<ControlLight>
    with SingleTickerProviderStateMixin {

  bool isLoading = false;
  final reference2Dashboard = FirebaseDatabase.instance.reference();
  bool showHint = false;
    List <String> hintTitles = ["Automáticas\n","Foto-periódicas\n","Feminizadas\n"] + globals.globalHintTitles;
    List <String> hintTexts = ["En todo el ciclo: 18/6 a 20/4\n","Mucho gusto\n","Blabla\n"] + globals.globalHintTexts;
    List <String> hintComments = ["Estas plantas, cuanto más luz reciban mejor, pero claramente necesitan un descanso\n","GrowBox\n","Es lo mas\n"] + globals.globalHintComments;
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
    print("Largo lista");
    print(hintTexts.length);
    _hintIndex = 0;
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
              Column(
                children: [
                  SizedBox(width: SizeConfig.blockSizeHorizontal*3, height:SizeConfig.blockSizeVertical*3),
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
                                Icon(GrowBoxIcons.icono_lux_svg,
                                    size: SizeConfig.blockSizeHorizontal*20,
                                    color: Color(0xFFBBB641)),
                                Text('${globals.controlData.onHour
                                    .toInt()}:00hs',
                                    style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*9, color: Colors.grey)),
                              ]
                          ),
                        ),
                        onPressed: () {
                          changePeriod(context,
                              globals.controlData.onHour.toInt(),
                              globals.controlData.offHour.toInt(),
                              true, false);
                        }
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*3, height:SizeConfig.blockSizeVertical*3),
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
                                Icon(GrowBoxIcons.icono_lux_svg,
                                    size: SizeConfig.blockSizeHorizontal*20,
                                    color: Colors.grey),
                                Text('${globals.controlData.offHour
                                    .toInt()}:00hs',
                                    style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*9, color: Colors.grey)),
                              ]
                          ),
                        ),
                        onPressed: () {
                          changePeriod(context,
                              globals.controlData.onHour.toInt(),
                              globals.controlData.offHour.toInt(),
                              true, false);
                        }
                    ),
                  ),
                  // SizedBox(width: SizeConfig.blockSizeHorizontal*3, height:SizeConfig.blockSizeVertical*3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly,
                    children: <Widget>[
                          globals.controlData.onHour >
                          globals.controlData.offHour ?
                      Text('Ciclo ${24 -
                          globals.controlData.onHour.toInt() +
                          globals.controlData.offHour
                              .toInt()}/${globals.controlData.onHour
                          .toInt() -
                          globals.controlData.offHour.toInt()}',
                          style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*8, color: Colors.grey))
                          : Text('Ciclo ${globals.controlData.offHour
                          .toInt() -
                            globals.controlData.onHour.toInt()}/${24 -
                            globals.controlData.offHour.toInt() +
                            globals.controlData.onHour.toInt()}',
                          style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*8, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
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
        )

        ]);
  }

  void _updateParent(int init, int end) {
    setState((){
      globals.controlData.onHour = init;
      globals.controlData.offHour = end;
      reference2Dashboard
          .child("growboxs/"
          +widget.user+"/control/OnHour")
          .set(init);
      Future.delayed(const Duration(milliseconds: 1000), ()
      {
        reference2Dashboard
            .child("growboxs/"
            + widget.user + "/control/OffHour")
            .set(end);
      });
    });
  }

  changePeriod(BuildContext context, int init, int end, bool isFP, bool isFI) {
    return showDialog(context: context, builder: (BuildContext context){
      return StatefulBuilder(
          builder: (context, setState) {
            void _updateLabels(int init, int end, int laps) {
              _updateParent(init, end);
              setState(() {
                globals.controlData.onHour = init;
                globals.controlData.offHour = end;
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
                            Text('${_formatIntervalTime(globals.controlData.onHour.toInt(), globals.controlData.offHour.toInt())}',
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



