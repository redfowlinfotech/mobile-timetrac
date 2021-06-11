import 'package:about/about.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "About Us",
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 50),
              Text(
                'Product Owned by',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Image.asset(
                'assets/redfowl.png',
                scale: 6,
              ),
              Container(height: 50),
              InkWell(
                  onTap: () async {
                    try {
                      await launch('http://redfowlinfotech.com/');
                    } catch (e) {}
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.language),
                      Container(
                        width: 30,
                      ),
                      Text('Website'),
                    ],
                  )),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(bottom: 30),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Developed with ♥ by'),
                          TextButton(
                              onPressed: () async {
                                try {
                                  await launch('https://xdrop.app/support');
                                } catch (e) {}
                              },
                              child: Text(
                                'Project X ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700),
                              ))
                        ],
                      ))),
            ]),
      ),
    );
  }
}
