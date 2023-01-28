import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocal/services/firebase_crud.dart';
import 'package:vocal/services/user_crud.dart';
import 'package:vocal/utility/app_colors.dart';
import 'package:vocal/utility/utility.dart';

class AddEntries extends StatefulWidget {
  DateTime date;
  TimeOfDay startTime;
  String numEntries;
  String timePerClass;

  AddEntries(
      {required this.date,
      required this.startTime,
      required this.numEntries,
      required this.timePerClass,
      super.key});

  @override
  State<AddEntries> createState() => _AddEntriesState();
}

class _AddEntriesState extends State<AddEntries> {
  bool isLoading = false;
  TextEditingController timeinput = TextEditingController();
  final Stream<QuerySnapshot> collectionReference = UserCrud.readClassUsers();

  Map<String, dynamic> users = {};

  String formatTime(TimeOfDay time) {
    DateTime parsedTime =
        DateFormat.jm().parse(time.format(context).toString());

    String formattedTime = DateFormat('hh:mm a').format(parsedTime);
    return formattedTime;
  }

  Widget singleItemList(
      int index,
      TextEditingController? controller1,
      TextEditingController? controller2,
      List itemList,
      String? initialValue,
      List<DocumentSnapshot> doc) {
    Item item = itemList[index];

    DropdownMenuItem<String> menuItem = const DropdownMenuItem<String>(
      value: 'Select',
      child: Text('Select'),
    );

    if (doc.isEmpty) {
      initialValue = 'Select';
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      //margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding:
          const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0, bottom: 0.0),
      child: Column(children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      readOnly: true,
                      //initialValue: item.start.toString(),
                      controller: controller1,
                      /* onChanged: (text) {
                        takeStartTime(text, index);
                      }, */
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: Colors.white),
                          helperStyle: TextStyle(color: Colors.white)),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: itemList[index].start,
                          context: context,
                        );

                        if (pickedTime != null) {
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());

                          String formattedTime =
                              DateFormat('hh:mm a').format(parsedTime);
                          controller1?.text = formattedTime;
                          setState(() {
                            itemList[index].start = pickedTime;
                          });
                        } else {}
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 130.0,
                    alignment: Alignment.center,
                    child: DropdownButton(
                      style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis),
                      isDense: false,
                      isExpanded: true,
                      value: initialValue,
                      hint: const Text('Select Name'),
                      underline: Container(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: doc.map((DocumentSnapshot docSnap) {
                        Map<String, dynamic> d =
                            docSnap.data() as Map<String, dynamic>;

                        return DropdownMenuItem<String>(
                          value: d['phone'] + '%%' + d['name'],
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 130.0,
                                        child: Text(
                                          d['name'],
                                          style: const TextStyle(fontSize: 18),
                                          //softWrap: false,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(d['phone'],
                                    style: const TextStyle(fontSize: 14))
                              ]),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        List phoneAndName = newValue!.split('%%');
                        setState(() {
                          defVal[index] = newValue;
                          itemList[index].name = phoneAndName[1];
                          itemList[index].id = phoneAndName[0];
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      controller: controller2,
                      readOnly: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: Colors.white)),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: itemList[index].end,
                          context: context,
                        );

                        if (pickedTime != null) {
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());

                          String formattedTime =
                              DateFormat('hh:mm a').format(parsedTime);
                          controller2?.text = formattedTime;
                          setState(() {
                            itemList[index].end = pickedTime;
                          });
                        } else {}
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1.0,
          child: Container(
            color: Colors.grey[300],
          ),
        )
      ]),
    );
  }

  Map<String, TextEditingController> startTimeEditingControllers = {};
  Map<String, TextEditingController> endTimeEditingControllers = {};
  List<Item> itemList = [];
  String dropVal = '';
  List<String?> defVal = [];

  TimeOfDay changeEndTime(TimeOfDay startTimeOfDay, {int multiple = 1}) {
    DateTime customDateTime =
        DateTime(2023, 12, 12, startTimeOfDay.hour, startTimeOfDay.minute);

    TimeOfDay endTimeOfDay = TimeOfDay.fromDateTime(
        customDateTime.add(Duration(minutes: int.parse(widget.timePerClass))));

    return endTimeOfDay;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int entries = int.parse(widget.numEntries);
    TimeOfDay start = widget.startTime;
    itemList = <Item>[];
    defVal = <String?>[];

    for (int i = 0; i < entries; i++) {
      TimeOfDay end = changeEndTime(start);
      defVal.add(null);
      itemList.add(Item(start, end, null, '$i'));

      start = end;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: true,
        /* actions: [
          IconButton(
              onPressed: () async {
                List itemMap = [];
                List classScheduleList = [];

                for (var i = 0; i < itemList.length; i++) {
                  itemMap.add(itemList[i].toMap());
                  ClassSchedule clasSchedule =
                      ClassSchedule(itemList[i].id, itemMap);
                  classScheduleList
                      .add(clasSchedule.toMap()); //{phone, start, end}
                  itemMap = [];
                }
                var response = await FirebaseCrud.addClasses(
                    date: widget.date.toString(), entries: classScheduleList);

                if (response.code != 200) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(response.message.toString()),
                      );
                    },
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: Text(response.message.toString()));
                      });
                }
              },
              icon: const Icon(Icons.save))
        ], */
        title: Text(
          DateFormat('dd-MM-yyyy').format(widget.date).toString(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 68.0),
              shrinkWrap: true,
              itemCount: itemList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Start Time",
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Name",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "End Time",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                index -= 1;

                var textEditingController1 = TextEditingController(
                    text: formatTime(itemList[index].start));
                var textEditingController2 = TextEditingController(
                    text: formatTime(itemList[index].end));
                startTimeEditingControllers.putIfAbsent(
                    "$index", () => textEditingController1);
                endTimeEditingControllers.putIfAbsent(
                    "$index", () => textEditingController2);
                return singleItemList(
                    index,
                    startTimeEditingControllers['$index'],
                    endTimeEditingControllers['$index'],
                    itemList,
                    defVal[index],
                    snapshot.data!.docs);
                //return const CircularProgressIndicator();
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          bool isConnected = await Utility.checkInternet();

          if (isConnected) {
            setState(() {
              isLoading = true;
            });
            List itemMap = [];
            List classScheduleList = [];

            for (var i = 0; i < itemList.length; i++) {
              itemMap.add(itemList[i].toMap());
              ClassSchedule clasSchedule =
                  ClassSchedule(itemList[i].id, itemMap);
              classScheduleList.add(clasSchedule.toMap()); //{phone, start, end}
              itemMap = [];
            }

            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Save'),
                      content: const Text(
                          'Are you sure you want to save this schedule and notify students?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('cancel')),
                        TextButton(
                            onPressed: () async {
                              var response = await FirebaseCrud.addClasses(
                                  date: widget.date.toString(),
                                  entries: classScheduleList);
                              Navigator.pop(context);
                              if (response.code != 200) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                        response.message.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          content: Text(
                                        response.message.toString(),
                                        textAlign: TextAlign.center,
                                      ));
                                    });
                              }
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: const Text('continue')),
                      ],
                    ));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                      content: Text(
                    'Connectivity Issues!',
                    textAlign: TextAlign.center,
                  ));
                });
          }
        },
        label: isLoading
            ? const SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text(
                'Save',
                style: TextStyle(fontSize: 18.0),
              ),
        icon: const Icon(
          Icons.save,
          size: 30.0,
        ),
      ),
    );
  }
}

class Item {
  TimeOfDay start;
  TimeOfDay end;
  String? name;
  String? id;
  String status = 'scheduled';

  Item(this.start, this.end, this.name, this.id);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "start": start.toString(),
      "end": end.toString(),
      "status": status
    };
  }
}

class ClassSchedule {
  String? phone;
  List clasList = [];

  ClassSchedule(this.phone, this.clasList);

  Map<String, dynamic> toMap() {
    return {
      "name": phone,
      "classList": clasList,
    };
  }
}
