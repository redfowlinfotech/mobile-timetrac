import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

const double _fabDimension = 56.0;

class AddList extends StatefulWidget {
  MyHomePageState parent;
  AddList(this.parent);
  @override
  _AddListState createState() => _AddListState(parent);
}

class _AddListState extends State<AddList> {
  List<List<String>> subtask = [];
  MyHomePageState parent;
  _AddListState(this.parent);
  bool subtasks = false;
  getit(String thestring) {
    if (':'.allMatches(thestring).length == 0) {
      return 'seconds';
    } else if (':'.allMatches(thestring).length == 1) {
      return 'minutes';
    } else {
      return 'hours';
    }
  }

  @override
  void initState() {
    super.initState();
    print('init');
  }

  void dispose() {
    print('dispose');
    super.dispose();
  }

  snackbar(String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  int subtasktime = 10;
  List<bool> isEdit = List.filled(30, false);
  TextEditingController subtaskcontroller = TextEditingController();
  TextEditingController listcontroller = TextEditingController();
  timesum() {
    int sum = 0;
    for (int i = 0; i < subtask.length; i++) {
      sum += int.parse(subtask[i][1]);
    }

    return MyHomePageState.timeinhours(int.parse(sum.toString())) +
        ' ' +
        getit(MyHomePageState.timeinhours(int.parse(sum.toString())));
  }

  originaltimesum() {
    int sum = 0;
    for (int i = 0; i < subtask.length; i++) {
      sum += int.parse(subtask[i][1]);
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: () {
              parent.setState(() {
                MyHomePageState.controller = TextEditingController();
                MyHomePageState.selectedtime = 10;
              });
              Navigator.pop(context);
            }),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: RaisedButton.icon(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                  size: 15,
                ),
                label: Text(
                  'Next',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  if (MyHomePageState.controller.text.length == 0) {
                    snackbar('Task empty. Please enter a task');
                  } else if (MyHomePageState.selectedtime == 0) {
                    snackbar(
                        'Timer cannot be set to 0 seconds. Please enter a time');
                  } else {
                    parent.setState(() {
                      MyHomePageState.timerneeded = false;
                      MyHomePageState.loading = false;
                    });
                    if (MyHomePageState.controller.text.length != 0) {
                      String subtaskstring = '';
                      if (subtasks) {
                        if (subtask.length == 0) {
                          snackbar('Please Enter atleast one subtask');
                          return;
                        }
                        print('subtasklength ${subtask.length}');
                        for (int i = 0; i < subtask.length; i++) {
                          setState(() {
                            subtaskstring +=
                                '${subtask[i][0]}:${subtask[i][1]}:${subtask[i][2]}:${subtask[i][3]}?';
                          });
                        }
                      }
                      print(subtaskstring);
                      MyHomePageState.todolist.add([
                        MyHomePageState.controller.text, // todo texxt
                        subtasks
                            ? '${originaltimesum()}'
                            : '${MyHomePageState.selectedtime}', // todo time
                        '0', // strikethrough
                        '0', // play or pause
                        subtasks ? '$subtaskstring' : '0'
                      ]);
                    }

                    parent.setState(() {
                      MyHomePageState.controller = TextEditingController();
                      MyHomePageState.selectedtime = 10;
                    });

                    MyHomePageState.storelist();
                    Navigator.pop(context);
                  }
                }),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
              height: 100,
              padding: EdgeInsets.only(left: 10.0, right: 10),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: TextField(
                      controller: MyHomePageState.controller,
                      autofocus: true,
                      style: TextStyle(fontSize: 25),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a task',
                          hintStyle: TextStyle(fontSize: 25))),
                ),
              )),
          const SizedBox(height: 30),
          Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5),
              child: SwitchListTile(
                  title: Text('Set Timer',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black54,
                            height: 1.5,
                            fontSize: 16.0,
                          )),
                  value: !subtasks,
                  onChanged: (val) {
                    setState(() {
                      subtasks = !subtasks;
                    });
                  })),
          Container(
              height: 90,
              padding: EdgeInsets.only(left: 30.0, right: 30),
              child: Card(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          subtasks
                              ? '${timesum()}'
                              : '${MyHomePageState.timeinhours(MyHomePageState.selectedtime)} ${getit(MyHomePageState.timeinhours(MyHomePageState.selectedtime))}',
                          style: TextStyle(fontSize: 16),
                        )),
                    subtasks
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(right: 20),
                            child: ElevatedButton(
                                onPressed: () {
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
                                                  fontSize: 24,
                                                  color: Colors.grey),
                                              highlightedTextStyle: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black),
                                              time: DateTime(10),
                                              spacing: 50,
                                              isShowSeconds: true,
                                              itemHeight: 50,
                                              isForce2Digits: true,
                                              onTimeChange: (time) {
                                                setState(() {
                                                  MyHomePageState.selectedtime =
                                                      time.hour * 3600 +
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
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  icon: Icon(Icons.check),
                                                  label: Text('Done'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  }),
                                            ],
                                          ));
                                },
                                child: Text('change')))
                  ]))),
          const SizedBox(height: 30),
          Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5),
              child: SwitchListTile(
                  title: Text('Subtasks',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.black54, height: 1.5, fontSize: 16.0)),
                  value: subtasks,
                  onChanged: (val) {
                    setState(() {
                      subtasks = !subtasks;
                    });
                  })),
          subtasks
              ? Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20),
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: subtask.length,
                            itemBuilder: (context, subindex) {
                              return Card(
                                  color: Color(0xffF6F8F9),
                                  shadowColor: Color(0xffF6F8F9),
                                  child: ListTile(
                                    leading: Container(
                                        alignment: Alignment.center,
                                        width: 30,
                                        child: Text(
                                            '${subindex + 1}/${subtask.length}',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey))),
                                    title: isEdit[subindex]
                                        ? TextField(
                                            autofocus: true,
                                            controller: listcontroller,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Enter a sub-task',
                                                hintStyle:
                                                    TextStyle(fontSize: 15)))
                                        : Text(subtask[subindex][0]),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          Icons.alarm,
                                          color: Colors.grey,
                                          size: 15,
                                        ),
                                        Container(width: 5),
                                        Text(
                                            '${MyHomePageState.timeinhours(isEdit[subindex] ? subtasktime : int.parse(subtask[subindex][1]))} ${getit(MyHomePageState.timeinhours(isEdit[subindex] ? subtasktime : int.parse(subtask[subindex][1])))}',
                                            style: TextStyle(fontSize: 10)),
                                        isEdit[subindex]
                                            ? TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              new AlertDialog(
                                                                title: Text(
                                                                  'hours : minutes : seconds',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                content:
                                                                    TimePickerSpinner(
                                                                  is24HourMode:
                                                                      true,
                                                                  normalTextStyle: TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      color: Colors
                                                                          .grey),
                                                                  highlightedTextStyle: TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      color: Colors
                                                                          .black),
                                                                  time:
                                                                      DateTime(
                                                                          10),
                                                                  spacing: 50,
                                                                  isShowSeconds:
                                                                      true,
                                                                  itemHeight:
                                                                      50,
                                                                  isForce2Digits:
                                                                      true,
                                                                  onTimeChange:
                                                                      (time) {
                                                                    setState(
                                                                        () {
                                                                      subtasktime = time
                                                                                  .hour *
                                                                              3600 +
                                                                          time.minute *
                                                                              60 +
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
                                                                        Navigator.pop(
                                                                            context);
                                                                        setState(
                                                                            () {});
                                                                      }),
                                                                ],
                                                              ));
                                                },
                                                child: Text('change'))
                                            : Container()
                                      ],
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(isEdit[subindex]
                                            ? Icons.check
                                            : Icons.edit),
                                        onPressed: () {
                                          if (listcontroller.text.length == 0) {
                                            snackbar(
                                                'Task empty. Please enter a task');
                                          } else {
                                            if (isEdit[subindex] == false) {
                                              setState(() {
                                                subtasktime = int.parse(
                                                    subtask[subindex][1]);
                                                listcontroller =
                                                    TextEditingController(
                                                        text: subtask[subindex]
                                                            [0]);
                                              });
                                            } else {
                                              setState(() {
                                                subtask[subindex][0] =
                                                    listcontroller.text;
                                                subtask[subindex][1] =
                                                    '${subtasktime}';
                                                subtask[subindex][2] = '0';
                                                subtask[subindex][3] = '0';
                                                subtasktime = 10;
                                                subtaskcontroller =
                                                    TextEditingController();

                                                listcontroller =
                                                    TextEditingController();
                                              });
                                            }
                                            setState(() {
                                              isEdit[subindex] =
                                                  !isEdit[subindex];
                                            });
                                          }
                                        }),
                                  ));
                            }),
                        isEdit.contains(true)
                            ? Container()
                            : Card(
                                child: ListTile(
                                tileColor: Color(0xffF5F5F5),
                                title: TextField(
                                    controller: subtaskcontroller,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter a sub-task',
                                        hintStyle: TextStyle(fontSize: 15))),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      color: Colors.grey,
                                      size: 15,
                                    ),
                                    Text(' $subtasktime '),
                                    Text('${getit(subtasktime.toString())}'),
                                    TextButton(
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (context) =>
                                                  new AlertDialog(
                                                    title: Text(
                                                      'hours : minutes : seconds',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    content: TimePickerSpinner(
                                                      is24HourMode: true,
                                                      normalTextStyle:
                                                          TextStyle(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.grey),
                                                      highlightedTextStyle:
                                                          TextStyle(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.black),
                                                      time: DateTime(10),
                                                      spacing: 50,
                                                      isShowSeconds: true,
                                                      itemHeight: 50,
                                                      isForce2Digits: true,
                                                      onTimeChange: (time) {
                                                        setState(() {
                                                          subtasktime =
                                                              time.hour * 3600 +
                                                                  time.minute *
                                                                      60 +
                                                                  time.second;
                                                        });
                                                      },
                                                    ),
                                                    actions: [
                                                      RaisedButton.icon(
                                                          color: Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          icon:
                                                              Icon(Icons.check),
                                                          label: Text('Done'),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          }),
                                                    ],
                                                  ));
                                        },
                                        child: Text('change'))
                                  ],
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.check),
                                    onPressed: () {
                                      if (subtaskcontroller.text.length == 0) {
                                        snackbar(
                                            'Task empty. Please enter a task');
                                      } else {
                                        setState(() {
                                          subtask.add([
                                            subtaskcontroller
                                                .text, // todo texxt
                                            '${subtasktime}', // todo time
                                            '0', // strikethrough
                                            '0' // play or pause
                                          ]);
                                          subtasktime = 10;
                                          subtaskcontroller =
                                              TextEditingController();
                                        });
                                      }
                                    }),
                              ))
                      ],
                    ),
                  ))
              : Container(),
        ],
      ),
    );
  }
}
