import 'package:flutter/material.dart';
import 'package:anticoagulant_predictor/home_page.dart';

class LoginData {
  String username;
  String password;
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _loginData = LoginData();
  bool _obscurePasswordText = true;

  void _togglePasswordText() {
    setState(() {
      _obscurePasswordText = !_obscurePasswordText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color showPasswordColor = Theme.of(context).primaryColor;

    Widget usernameFieldWidget = TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Username',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'This field is required';
        }
      },
      onSaved: (String username){
        _loginData.username = username;
      },
    );

    Widget passwordFieldWidget = TextFormField(
      obscureText: _obscurePasswordText,
      decoration: InputDecoration(
          icon: Icon(Icons.lock),
          hintText: 'Password',
          suffix: IconButton(
            icon: Icon(
                Icons.remove_red_eye,
                color: _obscurePasswordText ? Colors.grey : showPasswordColor
            ),
            onPressed: _togglePasswordText,
          )
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'This field is required';
        }
      },
      onSaved: (String password){
        _loginData.password = password;
      },
    );

    Widget loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: (){
            if (_loginFormKey.currentState.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          },
          child: Text('LOGIN'),
        )
    );

    Widget forgotPasswordWidget = Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment(1.0, 0),
      child: Text('Forgot password?'),
    );

    /* Widget signupWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Don\'t have an account? '),
        GestureDetector(
          onTap: () {
            print("onTap called.");
          },
          child: Text('Sign up', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ],
    ); */

    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 42.0),
          child: Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset('assets/logo.png', height: 100,),
                  Column(
                      children: <Widget>[
                        usernameFieldWidget,
                        passwordFieldWidget,
                        forgotPasswordWidget,
                        loginButton,
                      ]
                  )
                ],
              )
          )
      ),
    );
  }
}