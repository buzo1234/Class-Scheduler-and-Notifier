import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocal/models/user.dart';
import 'package:vocal/screens/login_with_phone.dart';
import 'package:vocal/screens/student_profile_screen.dart';
import 'package:vocal/screens/user_profile_screen.dart';
import 'package:vocal/services/shared_refs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //most important thing is to initialise firebase in project
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPref sharedPref = SharedPref();
  UserInfoSave userLoad = UserInfoSave();

  loadSharedPrefs() async {
    try {
      UserInfoSave user = UserInfoSave.fromJson(await sharedPref.read("user"));

      setState(() {
        userLoad = user;
      });
    } catch (Excepetion) {
      print("Nothing found $Exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPrefs();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: userLoad.phone != null
            ? userLoad.role == 'teacher'
                ? UserProfileScreen(user: userLoad)
                : StudentProfileScreen(user: userLoad)
            : const LoginWithPhone(),
      ),
    );
  }
}
