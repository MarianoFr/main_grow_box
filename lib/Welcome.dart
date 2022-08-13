import 'package:flutter/material.dart';
import 'LogIn.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this,
            duration: Duration(milliseconds: 2000));
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);

    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new LoginScreen()));
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child:AnimatedLogo(animation: animation)
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  final Tween<double> _sizeAnim = Tween<double>(begin: 50.0, end: 100.0);

  AnimatedLogo({Key key, Animation animation})
      : super( key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity:animation.value,
      child: Container(
        height: _sizeAnim.evaluate(animation),
        width: 100.0,
        child: Image.asset('images/isotipoGrowBox.png'),
      )
    );
  }
}