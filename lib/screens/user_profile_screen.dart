import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vocal/models/day_entry.dart';
import 'package:vocal/models/user_shared_pref.dart';
import 'package:vocal/screens/add_student.dart';
import 'package:vocal/screens/create_schedule.dart';
import 'package:vocal/screens/edit_class_schedule.dart';
import 'package:vocal/screens/login_with_phone.dart';
import 'package:vocal/services/firebase_crud.dart';
import 'package:vocal/services/shared_refs.dart';
import 'package:vocal/utility/app_colors.dart';
import 'package:vocal/utility/table_utils.dart';

class UserProfileScreen extends StatefulWidget {
  UserLocalSave user;

  UserProfileScreen({required this.user, super.key});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readClasses();

  List<ClassSchedule>? _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Map<DateTime, List<ClassSchedule>> _groupedEvents = {};

  SharedPref sharedPref = SharedPref();
  UserLocalSave useDel = UserLocalSave();

  _groupEvents(List<ClassSchedule> events) {
    _groupedEvents = {};
    for (var event in events) {
      DateTime date = DateTime.utc(
          event.date!.year, event.date!.month, event.date!.day, 12);

      if (_groupedEvents[date] == null) {
        _groupedEvents[date] = [];
      }

      _groupedEvents[date]?.add(event);
    }
  }

  @override
  void initState() {
    super.initState();
    _groupedEvents = {};
    _selectedDay = _focusedDay;
    useDel = widget.user;
    _selectedEvents = _getEventsForDay(_selectedDay!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ClassSchedule> _getEventsForDay(DateTime givenDay) {
    for (var key in _groupedEvents.keys) {
      if (key.day == givenDay.day &&
          key.month == givenDay.month &&
          key.year == givenDay.year) {
        return _groupedEvents[key]!;
      }
    }

    return [];
  }

  List<ClassSchedule> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  String TimeString(String? time) {
    String? newTime = time?.substring(10, 15);
    DateTime timeNew = DateFormat('hh:mm').parse(newTime!);
    String formattedTime = DateFormat('hh:mm a').format(timeNew);

    return formattedTime;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents = _getEventsForDay(selectedDay);
    }
    _selectedEvents = _getEventsForDay(selectedDay);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(widget.user.name!.substring(0, 1).toUpperCase()),
              ),
              accountEmail: Text(
                widget.user.phone!,
                style: TextStyle(color: AppColors.backGroundColor),
              ),
              accountName: Text(
                widget.user.name!,
                style: TextStyle(color: AppColors.backGroundColor),
              ),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(214, 214, 214, 1),
                          width: 1.0))),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Students'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => (const AddStudents()),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Create Schedule'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => (const CreateSchedule()),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                sharedPref.remove("user");

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => (const LoginWithPhone()),
                    ),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      //backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          'Your Schedule',
          style: TextStyle(color: AppColors.blackColor),
        ),
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        /* actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'add students',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => (const AddStudents()),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.event),
            tooltip: 'create schedule',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => (const CreateSchedule()),
                ),
              );
            },
          ),
          IconButton(
              onPressed: () {
                sharedPref.remove("user");

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => (const LoginWithPhone()),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.logout)),
        ], */
        //automaticallyImplyLeading: true,
        backgroundColor: AppColors.whiteColor,
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<ClassSchedule> classData = [];

          if (!snapshot.hasData) {
            print("List is Empty");
            return Container();
          } else {
            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              var dateID = snapshot.data!.docs[i]['date'];

              DateTime dID =
                  DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(dateID);
              for (var cat in snapshot.data!.docs[i]['Entries']) {
                print('cat is ${cat.runtimeType}');
                var count = 0;

                for (var i = 0; i < cat['classList'].length; i++) {
                  if (cat['classList'][i]['status'] == 'rescheduled') {
                    count += 1;
                  } else {
                    break;
                  }
                }

                classData.add(ClassSchedule(
                    token: cat['classList'][count]['token'],
                    entry: cat,
                    name: cat['classList'][count]['name'],
                    phone: cat['name'],
                    date: dID,
                    end: cat['classList'][count]['end'],
                    start: cat['classList'][count]['start']));
              }
            }

            _groupEvents(classData);

            _selectedEvents = _getEventsForDay(_selectedDay!);

            /*  setState(() {
              _selectedEvents = _getEventsForDay(_selectedDay!);
            }); */

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  TableCalendar<ClassSchedule>(
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: const CalendarStyle(
                      rangeEndDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      rangeStartDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      withinRangeDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      holidayDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      weekendDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      outsideDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      defaultDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      todayDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      selectedDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 195, 0, 255),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      // Use `CalendarStyle` to customize the UI
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: _onDaySelected,
                    onRangeSelected: _onRangeSelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                      child: ListView.builder(
                    itemCount: _selectedEvents?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => (EditSchedule(
                                    userSchedule: _selectedEvents?[index],
                                  )),
                                ));
                          },
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(_selectedEvents?[index].name ?? ''),
                                Text(
                                  "+91-${_selectedEvents?[index].phone}",
                                  style: const TextStyle(fontSize: 13.0),
                                )
                              ]),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(TimeString(_selectedEvents?[index].start)),
                                const Icon(Icons.arrow_right_alt_outlined),
                                Text(TimeString(_selectedEvents?[index].end))
                              ]),
                        ),
                      );
                    },
                  ))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
