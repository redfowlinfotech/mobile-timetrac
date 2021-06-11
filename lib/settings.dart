import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsOnePage extends StatefulWidget {
  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  bool _dark = false;

  @override
  void initState() {
    super.initState();
    prefs();
  }

  prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('alarm');
    if (value != null) {
      setState(() {
        _dark = value;
      });
    }
  }

  update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('alarm', _dark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Notification Settings",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10.0),
              SwitchListTile(
                activeColor: Colors.black,
                contentPadding: const EdgeInsets.all(0),
                value: _dark,
                title: Text("Switch on Alarm"),
                onChanged: (val) {
                  setState(() {
                    _dark = val;
                  });
                  update();
                },
              ),
              _dark
                  ? Card(
                      margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: ListTile(
                          title: Text(
                            "Choose Ringtone",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ))
                  : Container(),
              const SizedBox(height: 60.0),
            ],
          )),
    );
  }
}
