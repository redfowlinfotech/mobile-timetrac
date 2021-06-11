import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetrac/settings.dart';
import 'package:timetrac/timerpage.dart';
import 'package:timetrac/tnc.dart';
import 'onboarding.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutus.dart';
import 'package:animations/animations.dart';
import 'addlist.dart';
import 'edittask.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:showcaseview/showcaseview.dart';

var login;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    login = prefs.getString('ONBOARD');
  } catch (e) {}
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TimeTrac',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: login == null ? OnBoardingPage() : MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static List<List<String>> todolist = [];
  static bool loading = false;
  void _incrementCounter() {
    setState(() {
      focusNode.requestFocus();
      loading = true;
    });
  }

  // TextEditingController textcontroller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();

  void timer(int index) {
    int temptime = int.parse(todolist[index][1]);
    Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (int.parse(todolist[index][1]) == 0 || todolist[index][3] == '0') {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            temptime--;
            todolist[index][1] = '$temptime';
          });
        }
      },
    );
  }

  int parentindex = 0;
  bool parentpause = true;
  void parenttimer() {
    int temptime = int.parse(todolist[parentindex][1]);
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        if (parentpause) {
          print(1);
          setState(() {
            t.cancel();
            parentindex = 0;
          });
        } else if (parentindex == todolist.length - 1 &&
            int.parse(todolist[parentindex][1]) == 0) {
          print(1);
          setState(() {
            t.cancel();
            parentpause = false;
            parentindex = 0;
          });
        } else if (int.parse(todolist[parentindex][1]) == 0) {
          print(1);
          setState(() {
            parentindex++;
            t.cancel();
          });
          parenttimer();
        } else {
          setState(() {
            temptime--;
            todolist[parentindex][1] = '$temptime';
          });
        }
      },
    );
  }

  void getlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> triallist = prefs.getStringList('todolist');
    print(triallist);
    print(1);
    int j = 1, k = 0;
    List<String> temp = [];
    if (triallist != null) {
      print(2);
      for (int i = 0; i < triallist.length; i++) {
        temp.add(triallist[i]);
        print(temp);
        if (k == 4) {
          todolist.add([temp[0], temp[1], temp[2], temp[3], temp[4]]);
          print(todolist);
          temp = [];
          k = 0;
        } else {
          k++;
        }
      }
    }
    setState(() {
      print(todolist);
    });

    print(todolist[0][0]);
  }

  @override
  void initState() {
    super.initState();
    getlist();
    focusNode = FocusNode();
  }

  displayShowCase() async {
    preferences = await SharedPreferences.getInstance();

    bool showCaseVisibilityStatus = preferences.getBool("displayShowCase");
    if (showCaseVisibilityStatus == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)
              .startShowCase([_one, _two, _three, _four, _five]));
      preferences.setBool("displayShowCase", false);
    }
  }

  static void storelist() async {
    print('storing');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> triallist = [];
    for (int i = 0; i < todolist.length; i++) {
      for (int j = 0; j < 5; j++) {
        triallist.add(todolist[i][j]);
      }
    }
    print(triallist);
    prefs.setStringList('todolist', triallist);
  }

  static timeinhours(int timeForTimer) {
    String timetodisplay;
    if (timeForTimer < 60) {
      timetodisplay = timeForTimer.toString();
    } else if (timeForTimer < 3600) {
      int m = timeForTimer ~/ 60;
      int s = timeForTimer - (60 * m);
      timetodisplay = m.toString() + ":" + s.toString();
    } else {
      int h = timeForTimer ~/ 3600;
      int t = timeForTimer - (3600 * h);
      int m = t ~/ 60;
      int s = t - (60 * m);
      timetodisplay = h.toString() + ":" + m.toString() + ":" + s.toString();
    }
    return timetodisplay;
  }

  static int selectedtime = 10;
  static bool timerneeded = false;
  static TextEditingController controller = TextEditingController();
  static Duration initialtimer = new Duration();
  static FocusNode focusNode;

  Route _createRoute(MyHomePageState parent, int index, int a, int runindex) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          a == 1 ? EditTask(parent, index) : TimerPage(index, runindex),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  List<bool> isSelected = List.filled(100000, false);
  SharedPreferences preferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final scrollcontroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        drawer: Container(
            width: 250,
            child: Drawer(
                child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                ),
                Container(
                  height: 20,
                ),
                ListTile(
                    tileColor: Color(0xffF6F8F9),
                    leading: Icon(Icons.people),
                    title: Text('About Us'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AboutScreen()),
                      );
                    }),
                // ListTile(
                //     tileColor: Color(0xffF6F8F9),
                //     leading: Icon(Icons.upload_rounded),
                //     title: Text('Upload data'),
                //     onTap: () {}),
                ListTile(
                    tileColor: Color(0xffF6F8F9),
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SettingsOnePage()),
                      );
                    }),
                ListTile(
                    tileColor: Color(0xffF6F8F9),
                    leading: Icon(Icons.book),
                    title: Text('Terms and Conditions'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AboutPage()),
                      );
                    }),
              ],
            ) // Populate the Drawer in the next step.
                )),
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'TimeTrac',
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.black,
            ),
            splashColor: Colors.black,
            splashRadius: 25,
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        body: ListView.builder(
          controller: scrollcontroller,
          itemCount: todolist.length,
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Column(children: [
                  Card(
                      color: Color(0xffF6F8F9),
                      shadowColor: Color(0xffF6F8F9),
                      child: Dismissible(
                          background: Container(
                            color: Colors.red,
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.greenAccent,
                            padding: EdgeInsets.only(right: 10),
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.edit, color: Colors.black),
                          ),
                          confirmDismiss: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              print(direction);
                              todolist.removeAt(index);
                              storelist();
                              setState(() {});
                            }
                            if (direction == DismissDirection.endToStart) {
                              print('right');
                              setState(() {
                                controller = TextEditingController(
                                    text: todolist[index][0]);
                                selectedtime = int.parse(todolist[index][1]);
                              });

                              Navigator.of(context)
                                  .push(_createRoute(this, index, 1, 0));
                            }
                          },
                          key: Key(todolist[index][0]),
                          child: ListTile(
                            onTap: () {
                              print('tap');
                              print(todolist[index][4]);
                              if (todolist[index][4] != '0') {
                                print(1);
                                setState(() {
                                  isSelected[index] = !isSelected[index];
                                });
                              }
                            },
                            title: Row(children: [
                              Expanded(
                                  child: Text(
                                todolist[index][0],
                                style: TextStyle(
                                  decoration: todolist[index][2] == '1'
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              )),
                              todolist[index][2] == '1'
                                  ? Container()
                                  : Text(
                                      timeinhours(
                                          int.parse(todolist[index][1])),
                                      style: TextStyle(fontSize: 20),
                                    )
                            ]),
                            subtitle: todolist[index][4] == '0'
                                ? Container()
                                : Text(
                                    'Subtasks - ${'?'.allMatches(todolist[index][4]).length}'),
                            leading: Container(
                                width: 30,
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    if (todolist[index][2] == '1') {
                                      setState(() {
                                        todolist[index][2] = '0';
                                      });
                                    } else {
                                      setState(() {
                                        todolist[index][2] = '1';
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: todolist[index][2] == '1'
                                            ? Color(0xFF006CFF)
                                            : Colors.white,
                                        border: Border.all(
                                            width: 2,
                                            color: todolist[index][2] == '1'
                                                ? Color(0xFF006CFF)
                                                : Colors.grey)),
                                    child: Icon(Icons.check,
                                        color: Colors.white, size: 10),
                                  ),
                                )),
                            trailing: todolist[index][2] == '1' ||
                                    parentpause == false
                                ? Container(
                                    width: 20,
                                  )
                                : IconButton(
                                    icon: Icon(Icons.play_arrow_rounded),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          _createRoute(this, index, 2, 0));
                                    }),
                          ))),
                  isSelected[index]
                      ? Container(
                          height: ('?'.allMatches(todolist[index][4]).length) *
                              65.toDouble(),
                          padding: EdgeInsets.only(left: 30),
                          child: ListView.builder(
                            controller: scrollcontroller,
                            itemCount:
                                ('?'.allMatches(todolist[index][4]).length),
                            itemBuilder: (context, subindex) {
                              List<List<String>> subtask = [];
                              if (todolist[index][4] != '0') {
                                for (int i = 0;
                                    i <
                                        ('?'
                                            .allMatches(todolist[index][4])
                                            .length);
                                    i++) {
                                  String text =
                                      todolist[index][4].split("?")[i];
                                  subtask.add([
                                    text.split(":")[0], // todo texxt
                                    text.split(":")[1], // todo time
                                    text.split(":")[2], // strikethrough
                                    text.split(":")[3], // play or pause
                                  ]);
                                }
                              }
                              return Card(
                                  color: Color(0xffF6F8F9),
                                  shadowColor: Color(0xffF6F8F9),
                                  child: Dismissible(
                                      background: Container(
                                        color: Colors.red,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      secondaryBackground: Container(
                                        color: Colors.greenAccent,
                                        padding: EdgeInsets.only(right: 10),
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.edit,
                                            color: Colors.black),
                                      ),
                                      confirmDismiss: (direction) {
                                        if (direction ==
                                            DismissDirection.startToEnd) {
                                          print(direction);
                                          subtask.removeAt(subindex);
                                          String subtaskstring = '';
                                          for (int i = 0;
                                              i < subtask.length;
                                              i++) {
                                            setState(() {
                                              subtaskstring +=
                                                  '${subtask[i][0]}:${subtask[i][1]}:${subtask[i][2]}:${subtask[i][3]}?';
                                            });
                                          }
                                          int sum = 0;
                                          for (int i = 0;
                                              i < subtask.length;
                                              i++) {
                                            sum += int.parse(subtask[i][1]);
                                          }
                                          setState(() {
                                            todolist[index][1] = '$sum';
                                            todolist[index][4] = subtaskstring;
                                          });

                                          storelist();
                                        }
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          print('right');
                                          setState(() {
                                            controller = TextEditingController(
                                                text: todolist[index][0]);
                                            selectedtime =
                                                int.parse(todolist[index][1]);
                                          });

                                          Navigator.of(context).push(
                                              _createRoute(this, index, 1, 0));
                                        }
                                      },
                                      key: Key(subtask[subindex][0]),
                                      child: ListTile(
                                        title: Row(children: [
                                          Expanded(
                                              child: Text(
                                            subtask[subindex][0],
                                            style: TextStyle(
                                              decoration: subtask[subindex]
                                                          [2] ==
                                                      '1'
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          )),
                                          subtask[subindex][2] == '1'
                                              ? Container()
                                              : Text(
                                                  timeinhours(int.parse(
                                                      subtask[subindex][1])),
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )
                                        ]),
                                        leading: Container(
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () {
                                                if (subtask[index][2] == '1') {
                                                  setState(() {
                                                    subtask[subindex][2] = '0';
                                                  });
                                                } else {
                                                  setState(() {
                                                    subtask[subindex][2] = '1';
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: subtask[subindex]
                                                                [2] ==
                                                            '1'
                                                        ? Color(0xFF006CFF)
                                                        : Colors.white,
                                                    border: Border.all(
                                                        width: 2,
                                                        color: subtask[subindex]
                                                                    [2] ==
                                                                '1'
                                                            ? Color(0xFF006CFF)
                                                            : Colors.grey)),
                                                child: Icon(Icons.check,
                                                    color: Colors.white,
                                                    size: 10),
                                              ),
                                            )),
                                        trailing: subtask[subindex][2] == '1' ||
                                                parentpause == false
                                            ? Container(
                                                width: 20,
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                    Icons.play_arrow_rounded),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      _createRoute(this, index,
                                                          2, subindex));
                                                }),
                                      )));
                            },
                          ))
                      : Container(),
                  index == todolist.length - 1
                      ? Container(height: 20)
                      : Container()
                ]));
          },
        ),
        bottomSheet: Container(
          height: loading ? 300 : 0,
          color: Colors.grey[300],
          child: Column(children: [
            TextField(
              controller: controller,
              cursorColor: Color(0xFF006CFF),
              cursorHeight: 25,
              focusNode: focusNode,
              decoration: InputDecoration(
                suffix: RaisedButton.icon(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    icon: Icon(Icons.send),
                    label: Text('Next'),
                    onPressed: () {
                      storelist();
                      setState(() {
                        focusNode.unfocus();
                        timerneeded = false;
                        loading = false;
                      });
                      if (controller.text.length != 0) {
                        todolist
                            .add([controller.text, '$selectedtime', '0', '0']);
                      }
                      selectedtime = 0;
                      controller.clear();
                    }),
                hintText: 'Type a Task',
                hintStyle: TextStyle(color: Colors.black, fontSize: 17),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  timerneeded = !timerneeded;
                });
              },
              leading: timerneeded
                  ? Icon(Icons.check_box_rounded)
                  : Icon(Icons.check_box_outline_blank_rounded),
              title: Text('timer'),
            ),
            Container(height: 20),
            timerneeded
                ? Container(
                    height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Default time (hh:mm:ss) :'),
                          Text('$selectedtime seconds'),
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) => new AlertDialog(
                                        title: Text(
                                          'hours : minutes : seconds',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        content: TimePickerSpinner(
                                          is24HourMode: true,
                                          normalTextStyle: TextStyle(
                                              fontSize: 24, color: Colors.grey),
                                          highlightedTextStyle: TextStyle(
                                              fontSize: 24,
                                              color: Colors.black),
                                          time: DateTime(0),
                                          spacing: 50,
                                          isShowSeconds: true,
                                          itemHeight: 50,
                                          isForce2Digits: true,
                                          onTimeChange: (time) {
                                            setState(() {
                                              selectedtime = time.hour * 3600 +
                                                  time.minute * 60 +
                                                  time.second;
                                            });
                                          },
                                        ),
                                        actions: [
                                          RaisedButton.icon(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              icon: Icon(Icons.check),
                                              label: Text('Done'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      ));
                            },
                            child: Text('change'),
                          )
                        ]),
                  )
                : Container(),
          ]),
        ),
        floatingActionButton: OpenContainer(
          transitionType: _transitionType,
          openBuilder: (BuildContext context, VoidCallback _) {
            return AddList(this);
          },
          closedElevation: 6.0,
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(_fabDimension / 2),
            ),
          ),
          closedColor: Colors.white,
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return SizedBox(
              height: _fabDimension,
              width: _fabDimension,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
              ),
            );
          },
        ));
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
}

const double _fabDimension = 56.0;
