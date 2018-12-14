import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Gender {
  Gender(this.name, this.value);

  final String name;
  final String value;
}

class Procedure {
  Procedure(this.name, this.value);

  final String name;
  final String value;
}

class PredictionRequestData {
  int age;
  Gender gender;
  Procedure procedure;
  double oldINR;
  double newINR;
  double oldDose;
}

class VerificationResponseData {
  final String status;

  VerificationResponseData({this.status});

  factory VerificationResponseData.fromJson(Map<String, dynamic> json) {
    return VerificationResponseData(
      status: json['verification'],
    );
  }
}

class PredictionResponseData {
  final double newDose;

  PredictionResponseData({this.newDose});

  factory PredictionResponseData.fromJson(Map<String, dynamic> json) {
    return PredictionResponseData(
      newDose: json['predicted_dose'],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  PredictionRequestData _predictionRequestData = PredictionRequestData();

  final _predictionRequestFormKey = GlobalKey<FormState>();
  final List<Gender> genders = <Gender>[Gender('Male','Male'), Gender('Female','Female'), Gender('Other','Other')];
  final List<Procedure> procedures = <Procedure>[Procedure('MVR','MVR'), Procedure('AVR','AVR'), Procedure('DVR','DVR'), Procedure('AF','AF')];
  bool _loaderStatus = false;
  var _testMessage = 'a';

  void _changeLoaderStatus(bool status) {
    setState(() {
      _loaderStatus = status;
    });
  }

  void _showTest(data) {
    setState(() {
      _loaderStatus = false;
      _testMessage = data;
    });
  }

  Future<VerificationResponseData> verifyPredictionData() async {

    var validationUrl = Uri.parse('https://prediciton-api-prototype.herokuapp.com/predictor/validate/');
    var request = new http.MultipartRequest("POST", validationUrl);

    request.fields['age'] = _predictionRequestData.age.toString();
    request.fields['gender'] = _predictionRequestData.gender.value;
    request.fields['procedure'] = _predictionRequestData.procedure.value;
    request.fields['oldINRValue'] = _predictionRequestData.oldINR.toString();
    request.fields['newINRValue'] = _predictionRequestData.newINR.toString();
    request.fields['oldDose'] = _predictionRequestData.oldDose.toString();
    request.send().then((response) {
      if (response.statusCode == 200) {
        Stream<String> responseStream = response.stream.toStringStream();
        JsonDecoder jsonDecoder;
        responseStream
            .listen((data) {
              json.decode(data);
              _showTest(data);
            }
        );
      } else {
        throw Exception('Failed to load post');
      }
    });
  }

  Future<PredictionResponseData> fetchPrediction() async {

    var validationUrl = Uri.parse('https://prediciton-api-prototype.herokuapp.com/predictor/validate/');
    var request = new http.MultipartRequest("POST", validationUrl);

    request.fields['age'] = _predictionRequestData.age.toString();
    request.fields['gender'] = _predictionRequestData.gender.value;
    request.fields['procedure'] = _predictionRequestData.procedure.value;
    request.fields['oldINRValue'] = _predictionRequestData.oldINR.toString();
    request.fields['newINRValue'] = _predictionRequestData.newINR.toString();
    request.fields['oldDose'] = _predictionRequestData.oldDose.toString();

    request.send().then((response) {
      if (response.statusCode == 200) {
        Stream<String> responseStream = response.stream.toStringStream();
        return responseStream.listen((data) => PredictionResponseData.fromJson(json.decode(data)));
      } else {
        throw Exception('Failed to load post');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget ageWidget = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Age',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
        },
        onSaved: (value) {
          _predictionRequestData.age = int.parse(value);
        }
    );

    Widget genderWidget = DropdownButtonFormField(
      hint: Text('Gender'),
      value: _predictionRequestData.gender,
      onChanged: (Gender newGender) {
        setState(() {
          _predictionRequestData.gender = newGender;
        });
      },
      items: genders.map((Gender gender) {
        return DropdownMenuItem<Gender>(
          value: gender,
          child: new Text(
            gender.name,
            style: new TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
//      validator: (value) {
//        if (value.isEmpty) {
//          return 'This field is required';
//        }
//      },
    );

    Widget procedureWidget = DropdownButtonFormField(
      hint: Text('Procedure'),
      value: _predictionRequestData.procedure,
      onChanged: (Procedure newProcedure) {
        setState(() {
          _predictionRequestData.procedure = newProcedure;
        });
      },
      items: procedures.map((Procedure procedure) {
        return DropdownMenuItem<Procedure>(
          value: procedure,
          child: new Text(
            procedure.name,
            style: new TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
//      validator: (value) {
//        if (value.isEmpty) {
//          return 'This field is required';
//        }
//      },
    );

    Widget oldINRWidget = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Old INR Reading',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
        },
        onSaved: (value) {
          _predictionRequestData.oldINR = double.parse(value);
        }
    );

    Widget newINRWidget = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'New INR Reading',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
        },
        onSaved: (value) {
          _predictionRequestData.newINR = double.parse(value);
        }
    );

    Widget oldDoseWidget = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Old Warfarine Dose',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
        },
        onSaved: (value) {
          _predictionRequestData.oldDose = double.parse(value);
        }
    );

    Widget loaderWidget = _loaderStatus ? CircularProgressIndicator() : Container();

    Widget newDoseWidget = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: FutureBuilder<PredictionResponseData>(
          future: fetchPrediction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _changeLoaderStatus(false);
              return Text('Predicted new dose is ${snapshot.data.newDose} mg');
            }
            return Container();
          },
        )
    );

    Widget predictButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: (){
            if (_predictionRequestFormKey.currentState.validate()) {
              _changeLoaderStatus(true);
              verifyPredictionData();
//              fetchPrediction();
            }
          },
          child: Text('PREDICT'),
        )
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Anticoagulant Predictor'),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.0),
            child: Form(
                key: _predictionRequestFormKey,
                child: ListView(
                  children: <Widget>[
                    ageWidget,
                    genderWidget,
                    procedureWidget,
                    oldINRWidget,
                    newINRWidget,
                    oldDoseWidget,
                    newDoseWidget,
                    loaderWidget,
                    predictButton,
                    Text(_testMessage)
                  ],
                )
            )
        )
    );
  }
}
