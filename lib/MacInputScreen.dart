import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Tabs.dart';
import 'Welcome.dart';
import 'sizeConfig.dart';

class MacInput extends StatefulWidget {

  final String user;
  const MacInput({this.user});
  _MacInputState createState() => _MacInputState();

}

class _MacInputState extends State<MacInput> {

  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.reference();
  // maintains validators and state of form fields
  var _formKey = new GlobalKey<FormState>();
  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;
  // managed after response from server
  bool _isInvalidUser = false;
  String mac;
  bool _isLoggedIn = false;
  TextEditingController controller;
  bool showHint = false;
  int _hintButSize = 15;


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
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Welcome()),
            (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton:  IconButton(
        icon: Icon(
          Icons.logout, color: Colors.white, size: 40,),
        onPressed: handleLogOutPopup,
        padding: EdgeInsets.only(right: 40.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(0.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/wallPaper2.jpg"),
            fit: BoxFit.fill,
            ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0,-0.8),
                child: showLogo()
            ),
            Align(
              alignment: Alignment(0,-0.25),
                child: showIsotipo()
            ),
            Align(
              alignment: Alignment(0,0.6),
              child: ModalProgressHUD(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: buildLoginForm(context),
                  ),
                ),
                inAsyncCall: _isInAsyncCall,
                // demo of some additional parameters
                opacity: 0.5,
                progressIndicator: CircularProgressIndicator(),
              ),
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
                      color: Color.fromRGBO(10, 10, 10, 1),
                      margin: EdgeInsets.only(top: 50, bottom: 30),
                      child: Stack(
                        children: [
                            RichText(
                              text: TextSpan(
                                  style:GoogleFonts.miriamLibre(),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:"MAC:\n",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: SizeConfig.blockSizeHorizontal*6,
                                      ),
                                    ),
                                    TextSpan(
                                      text:"Este código identifica a su GrowBox. Lo puede encontrar en la caja del mismo.\n"
                                          "Ingrese los 17 caracteres incluyendo los \":\", luego presione aceptar.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: SizeConfig.blockSizeHorizontal*4,
                                      ),
                                    ),
                                  ])
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
                  //backgroundColor: Colors.orange,
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
          ],
        ),
      ),
    );
  }
  bool growBoxExists = false;
  Widget buildLoginForm(BuildContext context) {
    // run the validators on reload to process async results
    _formKey.currentState?.validate();
    return Form(
      key: this._formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller,
              maxLength: 17,
              decoration: InputDecoration(
                hintText: 'Introduzca MAC incluyendo los \" : \"',
                hintStyle: TextStyle(color: Colors.white),
                errorStyle: TextStyle(color: Colors.white, fontSize: 20)
              ),
              style: TextStyle(fontSize: 20.0, color: Colors.white),
              onChanged: (String value) {
                if( value.length == 17 ) {
                  try {
                    databaseReference
                        .child('users')
                        .once()
                        .then((DataSnapshot snapshot) {
                      setState(() {
                        growBoxExists = snapshot.value[value]['GBconnected'];
                      });
                    });
                  } catch (error) {
                    setState(() {
                      growBoxExists = false;
                    });
                  }
                }
              },
              validator: (String value) {
                try {
                  databaseReference
                      .child('users')
                      .once()
                      .then((DataSnapshot snapshot) {
                    setState(() {
                      growBoxExists = snapshot.value[value]['GBconnected'];
                    });
                  });
                } catch(error) {
                  setState(() {
                    growBoxExists = false;
                  });
                }
                return growBoxExists ? null : "GrowBox inexistente o desconectado";
              },
              onSaved: (value) => mac = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: RaisedButton(
              onPressed: validateAndSubmit,
              child: Text('Aceptar', style: TextStyle(fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }

  void validateAndSubmit() {
    if ( _formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      _isInvalidUser = false;
      _isLoggedIn = true;
      if (_isLoggedIn)
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new Tabs(mac: mac, user: widget.user)));
    }
  }

  Widget showIsotipo() {
    return new Hero(
      tag: 'isotipo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 100.0,
          child: Image.asset('images/isotipoGrowBox.png'),
        ),
      ),
    );
  }

  Widget showLogo() {
    return new Hero(
      tag: 'logotipo',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 75.0,
          child: Image.asset('images/logotipoGrowBox.png'),
      ),
    );
  }

}
