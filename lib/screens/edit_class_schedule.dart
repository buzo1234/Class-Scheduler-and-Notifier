import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocal/models/day_entry.dart';
import 'package:vocal/services/user_crud.dart';
import 'package:vocal/utility/app_colors.dart';
import 'package:http/http.dart' as http;

class EditSchedule extends StatefulWidget {
  ClassSchedule? userSchedule;

  EditSchedule({super.key, required this.userSchedule});

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String TimeString(String? time) {
    String? newTime = time?.substring(10, 15);
    DateTime timeNew = DateFormat('hh:mm').parse(newTime!);
    String formattedTime = DateFormat('hh:mm a').format(timeNew);

    return formattedTime;
  }

  void sendPushMessage(String token, String body, String title) async {
    print('Token : $token and body is : $body');
    try {
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
    } catch (e) {
      print(e);
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
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userSchedule?.name ?? '',
              style: const TextStyle(fontSize: 30.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              widget.userSchedule?.phone ?? '',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Start',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      TimeString(widget.userSchedule?.start),
                      style: const TextStyle(fontSize: 30.0),
                    )
                  ],
                ),
                const Icon(Icons.arrow_right_alt_outlined),
                Column(
                  children: [
                    const Text(
                      'End',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      TimeString(widget.userSchedule?.end),
                      style: const TextStyle(fontSize: 30.0),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 3.0),
                          height: 60.0,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: const Center(
                            child: Text(
                              'Cancel Class',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 19.0),
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
                                color: Color.fromARGB(179, 33, 149, 243),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: InkWell(
                              onTap: () async {
                                String tokenOfStudent =
                                    await UserCrud.getUserToken(
                                        widget.userSchedule?.phone);
                                print('Token of Student is : $tokenOfStudent');
                                sendPushMessage(
                                    tokenOfStudent,
                                    'New start time at ${TimeString(widget.userSchedule?.start)}',
                                    'Class Rescheduled!');
                                print('executed');
                              },
                              child: const Center(
                                child: Text(
                                  'Save Changes',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19.0),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
