import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Dashboard.dart';
import 'package:GrowBox/grow_box_icons_icons.dart';
import 'Welcome.dart';
import 'sizeConfig.dart';
import 'ControlLight.dart';
import 'ControlWater.dart';
import 'ControlHumidity.dart';
import 'ControlTemperature.dart';
import 'package:connectivity/connectivity.dart';
import 'connectivity_utils.dart';
import 'dart:async';

class Tabs extends StatefulWidget {

  final String mac;
  final String user;
  const Tabs({this.mac, this.user});
  _TabsState createState() => _TabsState();

}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {

  TabController _controller;
  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  int _selectedIndex = 0;
  StreamSubscription connectivitySubscription;

  @override
  void initState() {
    super.initState();
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          // title: Container(
          //   alignment: Alignment.center,
          //   height: 75.0,
          //   width: 75.0,
          //   child: Image.asset('images/isotipoGrowBox.png'),
          //   color: Colors.black,
          // ),
          // centerTitle: true,
          // actions: <Widget> [
          //   IconButton(
          //     icon: Icon(Icons.logout, color: Colors.white, size: SizeConfig.blockSizeHorizontal*12.0),
          //     onPressed: handleLogOutPopup,
          //     padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*10.0),
          //     ),
          // ],
          bottom: new PreferredSize(
              preferredSize: new Size(SizeConfig.blockSizeHorizontal*100, SizeConfig.blockSizeVertical*5
              ),
              child: new Container(
                height: SizeConfig.blockSizeVertical*9.48,
                width: SizeConfig.blockSizeHorizontal*100,
                color: Colors.black,
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: Color(0xFF9A67AC)
                    ),
                  overlayColor: MaterialStateProperty.all(Colors.black),
                  isScrollable: false,
                  indicatorWeight: 2,
                  indicatorColor:  Color(0xFFBBB641),
                  tabs: [
                    Tab(
                      //iconMargin: EdgeInsetsGeometry.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child:Icon(Icons.access_time,
                          size: SizeConfig.blockSizeHorizontal*13,
                          color:_selectedIndex==0 ? Color(0xFF321057) : Colors.grey
                        ),
                        //child: Text('Hola')
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(GrowBoxIcons.icono_lux_svg,
                          size: SizeConfig.blockSizeHorizontal*13,
                          color: _selectedIndex==1 ? Color(0xFF321057) : Colors.grey
                        ),
                      ),
                    ),
                    Tab(
                        child: Align(
                            alignment: Alignment.center,
                            child: Icon(GrowBoxIcons.icono_riego_svg,
                          size: SizeConfig.blockSizeHorizontal*13,
                          color: _selectedIndex==2 ? Color(0xFF321057) : Colors.grey
                          )
                        )
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(GrowBoxIcons.icono_temp_svg,
                          size: SizeConfig.blockSizeHorizontal*13,
                          color: _selectedIndex==3 ? Color(0xFF321057) : Colors.grey
                        ),
                      )
                    ),
                    Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Icon(GrowBoxIcons.icono_hum__suelo_svg,
                          size: SizeConfig.blockSizeHorizontal*13,
                          color: _selectedIndex==4 ? Color(0xFF321057) : Colors.grey
                        )
                      )
                    ),
                  ],
                  controller: _controller,
                ),
              ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Dashboard(mac: widget.mac, user: widget.user),
            ControlLight(widget.mac, widget.user),
            ControlWater(widget.mac, widget.user),
            ControlTemperature(widget.mac, widget.user),
            ControlHumidity(widget.mac, widget.user),
          ],
          controller: _controller,
        ),
        floatingActionButton: IconButton(
          icon: Icon(Icons.logout, color: Colors.white, size: SizeConfig.blockSizeHorizontal*12.0),
          onPressed: handleLogOutPopup,
          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*10.0),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? 'Ya tienes Internet'//${result.toString()}'
        : 'No tienes Internet';
    final color = hasInternet ? Colors.green : Colors.red;
      Utils.showTopSnackBar(Duration(seconds: 3), context, message, color);
  }

  handleLogOutPopup() {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Cerrar sesión",
      desc: "Desea cerrar sesión?",
      buttons: [
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.teal,
        ),
        DialogButton(
          child: Text(
            "Si",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: handleSignOut,
          color: Colors.teal,
        )
      ],
    ).show();
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    this.setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Welcome())
    );
  }
}

