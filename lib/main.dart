//GrowBox project
import 'package:flutter/material.dart';
import 'Welcome.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
//TODO:await connection firebase to display messages"cuenta no es legitima propietaria"
// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   debugPrintGestureArenaDiagnostics = false;
//   await Firebase.initializeApp(
//       options: FirebaseOptions(
//           apiKey: "AIzaSyD4OFDbpaeLsr0-K9ez_BPrht1USuN0xL8",
//           authDomain: "autobox-4e465.firebaseapp.com",
//           databaseURL: "https://autobox-4e465.firebaseio.com",
//           projectId: "autobox-4e465",
//           storageBucket: "autobox-4e465.appspot.com",
//           messagingSenderId: "54903343521",
//           appId: "1:54903343521:web:e85d79770365dee59fe3e0"
//       )
//   );
//   runApp(MyApp());
// }
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  debugPrintGestureArenaDiagnostics = false;
  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override  

  Widget build(BuildContext context) => OverlaySupport (
      child: MaterialApp(
        title: 'GrowBox',
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.purple,
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
          backgroundColor: Colors.black,
          //fontFamily:"GILC____",
          //textTheme: TextTheme(body1: TextStyle(fontSize: 23)),
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme,)),
        home: Welcome(),
        debugShowCheckedModeBanner: false
      )
    );
}

// GoogleFonts.robotoTextTheme(
// Theme.of(context).textTheme,
// ),