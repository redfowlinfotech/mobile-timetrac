import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_beep/flutter_beep.dart';

class TimerPage extends StatefulWidget {
  final runindex;
  final index;
  TimerPage(this.index, this.runindex);
  @override
  _TimerPageState createState() => _TimerPageState(index, runindex);
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
    print('init');
    start();
    getsubtask();
    defaultstart();
  }

  void dispose() {
    print('dispose');
    super.dispose();
    newtodolist[index][1] = originaltime.toString();
    runningindex = 0;
    if (newtodolist[index][4] == '0') {
      normaltimer.cancel();
    } else {
      bigtimer.cancel();
    }
  }

  final index, runindex;
  _TimerPageState(this.index, this.runindex);
  final FlutterTts flutterTts = FlutterTts();
  int originaltime;
  List<List<String>> subtask = [];
  List<List<String>> newtodolist = MyHomePageState.todolist;
  getsubtask() {
    if (newtodolist[index][4] != '0') {
      for (int i = 0; i < ('?'.allMatches(newtodolist[index][4]).length); i++) {
        String text = newtodolist[index][4].split("?")[i];
        subtask.add([
          text.split(":")[0], // todo texxt
          text.split(":")[1], // todo time
          text.split(":")[2], // strikethrough
          text.split(":")[3], // play or pause
        ]);
      }
    }
    setState(() {
      runningindex = runindex;
      if (runningindex > 0) {
        int sum = 0;
        for (int i = 0; i < runningindex + 1; i++) {
          sum += int.parse(subtask[i][1]);
        }
        newtodolist[index][1] = sum.toString();
      }
    });
  }

  speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak("Three. Two. One. Timer Starts now");
  }

  endspeak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak("Goodwork, You have completed your task!");
  }

  void timer(int index) async {
    speak();
    await Future.delayed(Duration(milliseconds: 2500));
    int temptime = int.parse(newtodolist[index][1]);
    normaltimer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (int.parse(newtodolist[index][1]) == 0 ||
            newtodolist[index][3] == '0') {
          if (int.parse(newtodolist[index][1]) == 0) {
            endspeak();
          }
          setState(() {
            newtodolist[index][3] = '0';
            timer.cancel();
          });
        } else {
          setState(() {
            temptime--;
            newtodolist[index][1] = '$temptime';
          });
        }
      },
    );
  }

  start() {
    setState(() {
      originaltime = int.parse(newtodolist[index][1]);
    });
  }

  resettimer() {
    setState(() {
      newtodolist[index][1] = originaltime.toString();
      runningindex = 0;
    });
  }

  getit(String thestring) {
    if (':'.allMatches(thestring).length == 0) {
      return 'seconds';
    } else if (':'.allMatches(thestring).length == 1) {
      return 'minutes';
    } else {
      return 'hours';
    }
  }

  int parentindex = 0;
  bool parentpause = true;
  int runningindex = 0;
  Timer normaltimer;
  Timer bigtimer;
  void parenttimer() async {
    print(1);
    speak();

    await Future.delayed(Duration(milliseconds: 2500));
    int temptime = int.parse(newtodolist[index][1]);
    bigtimer = Timer.periodic(
      Duration(seconds: 1),
      (Timer newtimer) {
        if (int.parse(newtodolist[index][1]) == 0 ||
            newtodolist[index][3] == '0') {
          print(2);
          if (int.parse(newtodolist[index][1]) == 0) {
            endspeak();
            resettimer();
            setState(() {
              newtodolist[index][3] = '0';
            });
          }
          print(3);
          setState(() {
            newtimer.cancel();
          });
        } else {
          print(1);
          setState(() {
            temptime--;
            newtodolist[index][1] = '$temptime';

            if ((originaltime - temptime) ==
                int.parse(subtask[runningindex][1])) {
              print(2);
              if (subtask.length != 1) {
                setState(() {
                  runningindex++;
                });
                FlutterBeep.beep();
              }
            }
          });
        }
      },
    );
  }

  getwords(String thestring) {
    if (':'.allMatches(thestring).length == 0) {
      return 'seconds';
    } else if (':'.allMatches(thestring).length == 1) {
      return 'minutes';
    } else {
      return 'hours';
    }
  }

  defaultstart() {
    if (newtodolist[index][3] == '0') {
      if (newtodolist[index][4] == '0') {
        timer(index);
      } else {
        parenttimer();
      }
      setState(() {
        newtodolist[index][3] = '1';
      });
    } else {
      setState(() {
        newtodolist[index][3] = '0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            newtodolist[index][0],
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Task at hand:',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            Container(
              height: 15,
            ),
            newtodolist[index][4] == '0'
                ? Card(
                    color: Colors.greenAccent,
                    shadowColor: Color(0xffF6F8F9),
                    child: ListTile(
                      leading: Container(
                          alignment: Alignment.center,
                          width: 30,
                          child: Text('$runningindex',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20))),
                      title: Row(children: [
                        Expanded(
                            child: Text(
                          newtodolist[index][0],
                          style: TextStyle(
                            fontSize: 15,
                            decoration: newtodolist[index][2] == '1'
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        )),
                      ]),
                    ))
                : SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Column(children: [
                            Card(
                                color: Colors.greenAccent,
                                shadowColor: Color(0xffF6F8F9),
                                child: ListTile(
                                  leading: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      child: Text('${runningindex + 1}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20))),
                                  title: Row(children: [
                                    Expanded(
                                        child: Text(
                                      subtask[runningindex][0],
                                      style: TextStyle(
                                        fontSize: 15,
                                        decoration:
                                            subtask[runningindex][2] == '1'
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                      ),
                                    )),
                                    subtask[runningindex][2] == '1'
                                        ? Container()
                                        : Text(
                                            MyHomePageState.timeinhours(
                                                    int.parse(
                                                        subtask[runningindex]
                                                            [1])) +
                                                ' ' +
                                                getwords(MyHomePageState
                                                    .timeinhours(int.parse(
                                                        subtask[runningindex]
                                                            [1]))),
                                            style: TextStyle(fontSize: 15),
                                          )
                                  ]),
                                )),
                            runningindex == subtask.length - 1
                                ? Container()
                                : Card(
                                    color: Color(0xffF6F8F9),
                                    shadowColor: Color(0xffF6F8F9),
                                    child: ListTile(
                                      leading: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          child: Text('${runningindex + 2}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20))),
                                      title: Row(children: [
                                        Expanded(
                                            child: Text(
                                          subtask[runningindex + 1][0],
                                          style: TextStyle(
                                            fontSize: 15,
                                            decoration:
                                                subtask[runningindex + 1][2] ==
                                                        '1'
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                          ),
                                        )),
                                        subtask[runningindex + 1][2] == '1'
                                            ? Container()
                                            : Text(
                                                MyHomePageState.timeinhours(
                                                        int.parse(subtask[
                                                            runningindex +
                                                                1][1])) +
                                                    ' ' +
                                                    getwords(MyHomePageState
                                                        .timeinhours(int.parse(
                                                            subtask[
                                                                runningindex +
                                                                    1][1]))),
                                                style: TextStyle(fontSize: 15),
                                              )
                                      ]),
                                    ))
                          ]))
                    ])),
            Container(height: 50),
            Container(
                width: width - 150,
                height: width - 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.red[200], shape: BoxShape.circle),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        MyHomePageState.timeinhours(
                            int.parse(newtodolist[index][1])),
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                      Text(
                        getit(MyHomePageState.timeinhours(
                            int.parse(newtodolist[index][1]))),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )
                    ])),
            Container(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                newtodolist[index][3] == '0'
                    ? IconButton(
                        icon: Icon(
                          Icons.refresh,
                          size: 30,
                        ),
                        onPressed: () {
                          resettimer();
                        })
                    : Container(),
                MaterialButton(
                  onPressed: () {
                    if (newtodolist[index][3] == '0') {
                      if (newtodolist[index][4] == '0') {
                        timer(index);
                      } else {
                        parenttimer();
                      }
                      setState(() {
                        newtodolist[index][3] = '1';
                      });
                    } else {
                      setState(() {
                        newtodolist[index][3] = '0';
                      });
                    }
                  },
                  color: Color(0xffF6F8F9),
                  textColor: Colors.grey,
                  child: Icon(
                      newtodolist[index][3] == '0'
                          ? Icons.play_arrow_rounded
                          : Icons.pause,
                      size: 40),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                ),
                Container()
              ],
            ),
          ]),
        ));
  }
}
