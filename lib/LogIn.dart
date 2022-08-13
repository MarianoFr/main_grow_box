import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:GrowBox/MacInputScreen.dart';
import 'Tabs.dart';
import 'package:connectivity/connectivity.dart';
import 'connectivity_utils.dart';
import 'dart:async';
class LoginScreen extends StatefulWidget {

  final String title;
  LoginScreen({Key key, this.title}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  StreamSubscription connectivitySubscription;
  GoogleSignInAccount _currentUser;
  bool nosilentLog;

  @override
  void initState()  {
    nosilentLog = false;
    super.initState();
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleFirebase();
      }
    });
    _googleSignIn.signInSilently(); //Auto login if previous login was success
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  void _handleFirebase() async {
    GoogleSignInAuthentication googleAuth = await _currentUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final result =
    await firebaseAuth.signInWithCredential(credential);
    final User firebaseUser = result.user;

    if (firebaseUser != null) {
      // print(firebaseUser.uid);
      // print('Login');
      if( nosilentLog ) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new MacInput(user: firebaseUser.uid)));
      }
      else{
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new Tabs(user: firebaseUser.uid)));
      }
    }
  }

  Future<void> _handleSignIn() async {
    try {
      nosilentLog = true;
      await _googleSignIn.signIn();
    } catch (error) {

    }
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? 'Ya tienes Internet' //${result.toString()}'
        : 'No tienes Internet';
    final color = hasInternet ? Colors.green : Colors.red;
    Utils.showTopSnackBar(Duration(seconds:3), context, message, color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x0),
      body:
      Stack(
          children: <Widget>[
            new Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/wallPaper2.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  showIsotipo(),
                  showLogo(),
                  showPrimaryButton(),
                ],
              ),
            ),
          ]
      ),
    );
  }

  Widget showIsotipo() {
    return new Hero(
      tag: 'isotipo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('images/ISOTIPO GrowBOX fondo oscuro.png'),
        ),
      ),
    );
  }

  Widget showLogo() {
    return new Hero(
      tag: 'logotipo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 50.0,
          child: Image.asset('images/logotipoGrowBox.png'),
        ),
      ),
    );
  }
  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(75.0, 100.0, 75.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Color(0xFF3C214C),
            child: Align(
                alignment: Alignment(0,0),
                child: Text('Iniciar sesión',
                    style: TextStyle(fontSize: 25, color: Colors.white)
                )
            ),
            onPressed: () async {
              final result = await Connectivity().checkConnectivity();
              if(result==ConnectivityResult.none)
                showConnectivitySnackBar(result);
              else
                _handleSignIn();
            },
          ),
        ));
  }
}