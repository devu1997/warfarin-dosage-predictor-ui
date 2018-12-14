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

class PredictionData {
  int age;
  Gender gender;
  Procedure procedure;
  double oldINR;
  double newINR;
  double oldDose;
}

class PredictionResponse {
  double newDose;

  PredictionResponse(this.newDose);

  factory PredictionResponse.fromString(String data) {
    Map json = jsonDecode(data);
    return PredictionResponse(json['verification']);
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  PredictionData _predictionData = PredictionData();
  String _predictionResponseMessage = 'No response';

  final _predictionFormKey = GlobalKey<FormState>();
  final List<Gender> genders = <Gender>[Gender('Male','Male'), Gender('Female','Female'), Gender('Other','Other')];
  final List<Procedure> procedures = <Procedure>[Procedure('MVR','MVR'), Procedure('AVR','AVR'), Procedure('DVR','DVR'), Procedure('AF','AF')];

  void _showPrediction(int predictedNewDose) {
    setState(() {
      _predictionResponseMessage = 'New Warfarine Dosage is  $predictedNewDose  mg';
    });
  }

  void _test(predictedNewDose) {
    setState(() {
      _predictionResponseMessage = 'New Warfarine Dosage is  $predictedNewDose  mg';
    });
  }

  Future<PredictionResponse> fetchPrediction() async {
    var validationUrl = Uri.parse('https://prediciton-api-prototype.herokuapp.com/predictor/validate/');
    var request = new http.MultipartRequest("POST", validationUrl);

    request.fields['age'] = _predictionData.age.toString();
    request.fields['gender'] = _predictionData.gender.value;
    request.fields['procedure'] = _predictionData.procedure.value;
    request.fields['oldINRValue'] = _predictionData.oldINR.toString();
    request.fields['newINRValue'] = _predictionData.newINR.toString();
    request.fields['oldDose'] = _predictionData.oldDose.toString();

    request.send().then((response) {
      if (response.statusCode == 200) {
         Stream<String> responseStream = response.stream.toStringStream();
         return responseStream.listen((String data) => PredictionResponse.fromString(data));
//        return PredictionResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post');
      }
    });
    _showPrediction(6217);
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
    TextStyle textStyle = TextStyle(fontSize: 16, color: textColor);

    Widget ageWidget = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Age',
        ),
        style: textStyle,
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
        },
        onSaved: (value) {
          _predictionData.age = int.parse(value);
        }
    );

    Widget genderWidget = DropdownButtonFormField(
      hint: Text('Gender'),
      value: _predictionData.gender,
      onChanged: (Gender newGender) {
        setState(() {
          _predictionData.gender = newGender;
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
    );

    Widget procedureWidget = DropdownButtonFormField(
      hint: Text('Procedure'),
      value: _predictionData.procedure,
      onChanged: (Procedure newProcedure) {
        setState(() {
          _predictionData.procedure = newProcedure;
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
    );

    Widget oldINRWidget = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Old INR Reading',
        ),
        style: textStyle,
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
        },
        onSaved: (value) {
          _predictionData.oldINR = double.parse(value);
        }
    );

    Widget newINRWidget = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'New INR Reading',
        ),
        style: textStyle,
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
        },
        onSaved: (value) {
          _predictionData.newINR = double.parse(value);
        }
    );

    Widget oldDoseWidget = TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Old Warfarine Dose',
        ),
        style: textStyle,
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
        },
        onSaved: (value) {
          _predictionData.oldDose = double.parse(value);
        }
    );

    Widget newDoseWidget = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(_predictionResponseMessage)
    );

    Widget predictButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: (){
            if (_predictionFormKey.currentState.validate()) {
              fetchPrediction();
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
                key: _predictionFormKey,
                child: ListView(
                  children: <Widget>[
                    ageWidget,
                    genderWidget,
                    procedureWidget,
                    oldINRWidget,
                    newINRWidget,
                    oldDoseWidget,
                    newDoseWidget,
                    predictButton,
                  ],
                )
            )
        )
    );
  }
}
