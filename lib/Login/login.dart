import '../General/drawer.dart';
import 'loginmodel.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

class LoginPage extends StatefulWidget {
  static final String path = "lib/Login/login.dart";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<LoginModel> _list = List();
  bool _isLoading = false;
  bool passwordVisible;
  final TextEditingController userController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final FocusNode _userFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    passwordVisible = true;
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  signIn(String nik, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'nik': nik,
      'password': pass
    };
    /*var jsonResponse = null;*/
    var response = await http.post("${url}/CekLoginDFA?", body: data);
    if(response.statusCode == 200) {
      /*jsonResponse = json.decode(response.body)['Table'];*/
      _list = (json.decode(response.body)['Table'] as List)
          .map((data) => new LoginModel.fromJson(data)).toList();
      if(_list.length != 0) {
        if (_list[0].userid == nik && _list[0].password == pass) {
          setState(() {
            _isLoading = false;
            /*sharedPreferences.setString("token", jsonResponse['token']);*/
            Navigator.of(context).pushReplacementNamed(
              '/drawer', arguments: MyDrawer(name : _list[0].nama_karyawan, position : _list[0].jabatan, nik: _list[0].userid,),
            );
          });
        } else {
          setState(() {
            _isLoading = false;
            Flushbar(
              icon: Icon(Icons.highlight_off, color: Colors.red),
              message: 'Username or password was incorrect. Please try again',
              duration: Duration(seconds: 3),
              // Show it with a cascading operator
            )..show(context);
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          Flushbar(
            icon: Icon(Icons.highlight_off, color: Colors.red),
            message: 'Username or password was incorrect. Please try again',
            duration: Duration(seconds: 3),
          )..show(context);
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        Flushbar(
          icon: Icon(Icons.error_outline, color: Colors.red),
          message: 'Oops, something went wrong! Server Error!',
          duration: Duration(seconds: 3),
        )..show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper2(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.cyan, Colors.cyanAccent])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.cyan, Colors.lightBlueAccent])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper1(),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "MOBILE DFA",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.lightBlue])),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                controller: userController,
                focusNode: _userFocus,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _userFocus, _passwordFocus);
                },
                cursorColor: Colors.lightBlue,
                decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 15.8)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                controller: passwordController,
                obscureText: passwordVisible,
                focusNode: _passwordFocus,
                onFieldSubmitted: (value){
                  _passwordFocus.unfocus();
                },
                cursorColor: Colors.lightBlue,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15.8)),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              height: 50.0,
              /*padding: EdgeInsets.symmetric(horizontal: 15.0),*/
              margin: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: /*userController.text == "" || passwordController.text == "" ? (){
                  setState(() {
                    _isLoading = false;
                    Flushbar(
                      icon: Icon(Icons.highlight_off, color: Colors.red),
                      message: 'Username or Password cannot be blank!',
                      duration: Duration(seconds: 3),
                    )..show(context);
                  });} : */() {
                  setState(() {
                    _isLoading = true;
                  });
                  signIn(userController.text, passwordController.text);
                },//since this is only a UI app
                child: Text('SIGN IN',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          /*Center(
            child: Text("FORGOT PASSWORD ?", style: TextStyle(color:Colors.blue,fontSize: 12 ,fontWeight: FontWeight.w700),),
          ),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an Account ? ", style: TextStyle(color:Colors.black,fontSize: 12 ,fontWeight: FontWeight.normal),),
              Text("Sign Up ", style: TextStyle(color:Colors.blue, fontWeight: FontWeight.w500,fontSize: 12, decoration: TextDecoration.underline )),

            ],
          )*/
        ],
      ),
    );
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}