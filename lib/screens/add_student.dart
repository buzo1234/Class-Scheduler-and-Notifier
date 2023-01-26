import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vocal/services/user_crud.dart';
import 'package:vocal/utility/app_colors.dart';

class AddStudents extends StatefulWidget {
  const AddStudents({super.key});

  @override
  State<AddStudents> createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  final Stream<QuerySnapshot> collectionReference = UserCrud.readUsers();
  List<Map<String, dynamic>> userData = [];

  void studentList(List<Map<String, dynamic>> users) {
    userData = users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Add Students',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            print("List is Empty");
            return Container();
          } else {
            List<Map<String, dynamic>> userInfo =
                snapshot.data!.docs.map((DocumentSnapshot docSnapshot) {
              return docSnapshot.data() as Map<String, dynamic>;
            }).toList();

            studentList(userInfo);
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: const Border(
                              bottom: BorderSide(
                                  color: Color(0xFFE0E0E0), width: 1.0)),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userData[index]['name']!,
                                      style: const TextStyle(fontSize: 20.0)),
                                  Text(
                                    userData[index]['phone']!,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Switch(
                                // This bool value toggles the switch.
                                value: userData[index]['belong']!,
                                activeColor: Colors.green[700],
                                onChanged: (bool value) async {
                                  var response = await UserCrud.updateUser(
                                      belong: value,
                                      name: userData[index]['name'],
                                      phone: userData[index]['phone'],
                                      role: userData[index]['role']);
                                  if (response.code != 200) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            content: Text('Failed'),
                                          );
                                        });
                                  }

                                  // This is called when the user toggles the switch.
                                },
                              )
                            ],
                          ),
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
