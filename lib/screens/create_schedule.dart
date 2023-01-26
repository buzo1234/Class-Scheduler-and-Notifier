import 'package:flutter/material.dart';
import 'package:vocal/screens/add_entries.dart';
import 'package:vocal/utility/app_colors.dart';
import 'package:intl/intl.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({super.key});

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay st = TimeOfDay.now();

  _CreateScheduleState();

  @override
  void initState() {
    dateinput.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    timeinput.text = "";

    super.initState();
    textEditingController.text = '20';
    textEditingController2.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Create Entry',
          style: TextStyle(color: AppColors.blackColor),
        ),
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        backgroundColor: AppColors.whiteColor,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: dateinput, //editing controller of this TextField
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_today), //icon of text field
                labelText: "Select Date" //label text of field
                ),
            readOnly:
                true, //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                print(
                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
                print(
                    formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  selectedDate = pickedDate;
                  dateinput.text =
                      formattedDate; //set output date to TextField value.
                });
              } else {
                print("Date is not selected");
              }
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: textEditingController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.schedule),
              labelText: "Time/Class (mins)",
              suffixText: "mins ",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: textEditingController2,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.account_box_outlined),
              labelText: "Entries to Add",
              suffixText: "students ",
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: timeinput, //editing controller of this TextField
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.av_timer), //icon of text field
              labelText: "Enter Start Time",
              //label text of field
            ),
            readOnly:
                true, //set it true, so that user will not able to edit text
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );

              if (pickedTime != null) {
                DateTime parsedTime = DateFormat.jm()
                    .parse(pickedTime.format(context).toString());
                //converting to DateTime so that we can further format on different pattern.
                String formattedTime = DateFormat('hh:mm a').format(parsedTime);
                //DateFormat() is from intl package, you can format the time on any pattern you need.

                setState(() {
                  timeinput.text = formattedTime;
                  st = pickedTime; //set the value of text field.
                });
              } else {}
            },
          ),
          const Spacer(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEntries(
                date: selectedDate,
                startTime: st,
                numEntries: textEditingController2.text,
                timePerClass: textEditingController.text,
              ),
            ),
          );
        },
        label: const Text('Continue'),
        icon: const Icon(Icons.arrow_circle_right),
      ),
    );
  }
}
