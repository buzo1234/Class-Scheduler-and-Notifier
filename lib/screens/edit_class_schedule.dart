import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocal/models/day_entry.dart';
import 'package:vocal/services/firebase_crud.dart';
import 'package:vocal/services/user_crud.dart';
import 'package:vocal/utility/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:vocal/utility/utility.dart';

class EditSchedule extends StatefulWidget {
  ClassSchedule? userSchedule;

  EditSchedule({super.key, required this.userSchedule});

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  TextEditingController startInput = TextEditingController();
  TextEditingController endInput = TextEditingController();
  String? classTime;
  String? startTime;
  String? endTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime = widget.userSchedule?.start;
    endTime = widget.userSchedule?.end;
    startInput.text = TimeString(widget.userSchedule?.start);
    endInput.text = TimeString(widget.userSchedule?.end);
    classTime = TimeDifference(startTime, endTime);
  }

  String TimeDifference(String? start, String? end) {
    String? newStartTime = start?.substring(10, 15);
    String? newEndTime = end?.substring(10, 15);
    DateTime dtStart = DateFormat('hh:mm').parse(newStartTime!);
    DateTime dtEnd = DateFormat('hh:mm').parse(newEndTime!);

    if (dtEnd.hour < dtStart.hour) {
      return "Please Select Correct End Time";
    }

    if (dtEnd.hour == dtStart.hour && dtEnd.minute < dtStart.minute) {
      return "Please Select Correct End Time";
    }
    TimeOfDay timeDiff = TimeOfDay.fromDateTime(
        dtEnd.subtract(Duration(hours: dtStart.hour, minutes: dtStart.minute)));

    return TimeFormatter(timeDiff);
  }

  String TimeFormatter(TimeOfDay? time) {
    return "${time?.hour} hour and ${time?.minute} minutes";
  }

  String TimeString(String? time) {
    String? newTime = time?.substring(10, 15);
    DateTime timeNew = DateFormat('hh:mm').parse(newTime!);
    String formattedTime = DateFormat('hh:mm a').format(timeNew);

    return formattedTime;
  }

  TimeOfDay TimeStringToClass(String? time) {
    String? newTime = time?.substring(10, 15);
    DateTime timeNew = DateFormat('hh:mm').parse(newTime!);
    return TimeOfDay.fromDateTime(timeNew);
  }

  Future<bool> sendPushMessage(String token, String body, String title) async {
    try {
      print('Token is  $token');
      if (token == '') return false;
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAA0SP4R1I:APA91bGwIGSp9w4p5kbTAZgrM0mXyKGMU59iz19bMxegq51izl4DtlKF3WIl-BzDY3-ZSKczRCgK2o-c_rJBlZP3sgRfr0V5WE0OkLpxJ88J3umrZAjCU3Fh44TgnhSamoL1T_dGl3i8',
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'android': {
              'priority': 'high',
            },
            'notification': <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "channel_id"
            },
            "to": token
          }));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          'Edit Schedule',
          style: TextStyle(color: AppColors.blackColor),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 8.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            DefaultTextStyle(
              style: TextStyle(color: Colors.grey[700]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        width: 130.0,
                        child: Text(
                          widget.userSchedule?.name ?? '',
                          style: const TextStyle(fontSize: 18.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        widget.userSchedule?.phone ?? '',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              height: 1.0,
              color: Colors.grey[350],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: const Alignment(0.3, 0.0),
                          child: const Icon(Icons.edit),
                        ),
                        const Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    InkWell(
                      hoverColor: Colors.blue,
                      onTap: () {},
                      splashColor: Colors.blue,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: startInput,
                          style: const TextStyle(fontSize: 30.0),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black),
                              helperStyle: TextStyle(color: Colors.black)),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeStringToClass(startTime),
                              context: context,
                            );

                            if (pickedTime != null) {
                              DateTime parsedTime = DateFormat.jm()
                                  .parse(pickedTime.format(context).toString());

                              String formattedTime =
                                  DateFormat('hh:mm a').format(parsedTime);

                              setState(() {
                                startTime = pickedTime.toString();
                                startInput.text = formattedTime;
                                classTime = TimeDifference(startTime, endTime);
                              });
                            } else {}
                          },
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Icon(Icons.arrow_downward_sharp),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: const Alignment(0.3, 0.0),
                          child: const Icon(Icons.edit),
                        ),
                        const Text(
                          'End',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    InkWell(
                      hoverColor: Colors.blue,
                      onTap: () {},
                      splashColor: Colors.blue,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: endInput,
                          style: const TextStyle(fontSize: 30.0),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.black),
                              helperStyle: TextStyle(color: Colors.black)),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeStringToClass(endTime),
                              context: context,
                            );

                            if (pickedTime != null) {
                              DateTime parsedTime = DateFormat.jm()
                                  .parse(pickedTime.format(context).toString());

                              String formattedTime =
                                  DateFormat('hh:mm a').format(parsedTime);

                              setState(() {
                                endTime = pickedTime.toString();
                                endInput.text = formattedTime;
                                classTime = TimeDifference(startTime, endTime);
                              });
                            } else {}
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Class time will be : '),
                  Text(
                    classTime ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )
                ]),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 3.0),
                            height: 60.0,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.red, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0))),
                            child: InkWell(
                              onTap: () async {
                                bool isConnected =
                                    await Utility.checkInternet();

                                if (isConnected) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Delete Class?'),
                                            content: Text(
                                                'Are you sure you want to delete/cancel this class and notify ${widget.userSchedule?.name}?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('cancel')),
                                              TextButton(
                                                  onPressed: () async {
                                                    var response = FirebaseCrud
                                                        .deleteClass(
                                                            docId: DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(widget
                                                                        .userSchedule
                                                                        ?.date
                                                                    as DateTime),
                                                            entry: widget
                                                                .userSchedule
                                                                ?.entry);
                                                    String tokenOfStudent =
                                                        await UserCrud
                                                            .getUserToken(widget
                                                                .userSchedule
                                                                ?.phone);

                                                    bool isSent =
                                                        await sendPushMessage(
                                                            tokenOfStudent,
                                                            'Your class on ${DateFormat('dd-MM-yyyy').format(widget.userSchedule?.date as DateTime)} that was to start from ${TimeString(widget.userSchedule?.start)} is cancelled.',
                                                            'Class Cancelled!');
                                                    Navigator.pop(context);
                                                    if (isSent) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return const AlertDialog(
                                                            content: Text(
                                                              "Student is Notified!",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return const AlertDialog(
                                                                content: Text(
                                                              "Some Error Occured",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ));
                                                          });
                                                    }
                                                  },
                                                  child:
                                                      const Text('continue')),
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
                              splashColor: Colors.red,
                              child: Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 19.0),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 3.0),
                            height: 60.0,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(229, 33, 149, 243),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () async {
                                bool isConnected =
                                    await Utility.checkInternet();

                                if (isConnected) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Save Edit?'),
                                            content: Text(
                                                'Are you sure you want to save this time and notify ${widget.userSchedule?.name}?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('cancel')),
                                              TextButton(
                                                  onPressed: () async {
                                                    String tokenOfStudent =
                                                        await UserCrud
                                                            .getUserToken(widget
                                                                .userSchedule
                                                                ?.phone);

                                                    bool isSent =
                                                        await sendPushMessage(
                                                            tokenOfStudent,
                                                            'New class timings from ${TimeString(startTime)} to ${TimeString(endTime)}',
                                                            'Class Rescheduled!');
                                                    Navigator.pop(context);
                                                    if (isSent) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return const AlertDialog(
                                                            content: Text(
                                                              "Student is Notified!",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return const AlertDialog(
                                                                content: Text(
                                                              "Some Error Occured",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ));
                                                          });
                                                    }
                                                  },
                                                  child:
                                                      const Text('continue')),
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
                              child: Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19.0),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
