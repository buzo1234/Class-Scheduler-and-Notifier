import 'package:flutter/material.dart';
import 'package:vocal/models/day_entry.dart';
import 'package:vocal/utility/app_colors.dart';

class EditSchedule extends StatefulWidget {
  ClassSchedule? userSchedule;

  EditSchedule({super.key, required this.userSchedule});

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
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
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: const [],
                ),
                const Icon(Icons.arrow_right_alt_outlined),
                Column(
                  children: const [],
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
                          height: 40.0,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: const Center(
                            child: Text(
                              'Cancel Class',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.0),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 3.0),
                          height: 40.0,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: const Center(
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.0),
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
