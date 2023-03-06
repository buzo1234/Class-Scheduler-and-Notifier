import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vocal/screens/register_with_phone.dart';
import 'package:vocal/screens/verification_screen.dart';
import 'package:vocal/services/user_crud.dart';
import 'package:vocal/utility/app_colors.dart';
import 'package:vocal/utility/app_dimens.dart';
import 'package:vocal/utility/utility.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  AppDimens appDimens;
  TextEditingController textEditingController;
  Size size;
  MediaQueryData mediaQuerydata;
  bool isLoading = false;
  String? mtoken = " ";
  bool loadingLogin = false;

  _LoginWithPhoneState()
      : size = const Size(20, 20),
        appDimens = AppDimens(const Size(20, 20)),
        mediaQuerydata = const MediaQueryData(),
        textEditingController = TextEditingController();

  void getToken() async {
    await messaging.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadingLogin = false;
    getToken();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuerydata = MediaQuery.of(context);
    size = MediaQuery.of(context).size;
    appDimens = AppDimens(size);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: size.height - mediaQuerydata.padding.top),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    const FlutterLogo(
                      size: 150,
                    ),
                    const Spacer(),
                    Container(
                      margin: EdgeInsets.only(top: appDimens.paddingw2),
                      alignment: Alignment.center,
                      child: Text(
                        "Login to continue",
                        style: TextStyle(
                          fontSize: appDimens.text20,
                          color: AppColors.greyText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: appDimens.paddingw20,
                    ),
                    emailMobileView(),
                    SizedBox(
                      height: appDimens.paddingw20,
                    ),
                    Utility.loginButtonsWidget(
                      "",
                      loadingLogin ? "Loading..." : "Continue",
                      () {
                        loadingLogin ? null : continueClick();
                      },
                      AppColors.blackColor,
                      AppColors.blackColor,
                      appDimens,
                      AppColors.whiteColor,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => (const RegisterWithPhone()),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: appDimens.paddingw6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Spacer(),
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: appDimens.text16,
                              ),
                            ),
                            Text(
                              "Register Now",
                              style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: appDimens.text16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Spacer(),
                    Container(
                      width: size.width,
                      margin: EdgeInsets.only(bottom: appDimens.paddingw16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: appDimens.paddingw18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isLoading ? Utility.progress(context) : Container(),
          ],
        ),
      ),
    );
  }

  Widget emailMobileView() {
    return Container(
      margin: EdgeInsets.only(
        left: appDimens.paddingw16 * 2,
        right: appDimens.paddingw16 * 2,
        bottom: appDimens.paddingw16,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(0, 1),
        //     blurRadius: 2,
        //     color: Colors.black54,
        //   ),
        // ],
        border: Border.all(color: AppColors.blackColor, width: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: appDimens.paddingw6,
              right: appDimens.paddingw6,
            ),
            child: Text(
              "+91",
              style: TextStyle(
                  fontSize: appDimens.text16, color: AppColors.greyText),
            ),
          ),
          Container(
            color: AppColors.blackColor,
            width: 0.5,
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: appDimens.paddingw6,
            ),
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                  fontSize: appDimens.text16, color: AppColors.greyText),
              controller: textEditingController,
              maxLength: 10,
              decoration: InputDecoration(
                hintText: "Mobile Number",
                counterText: "",
                hintStyle: TextStyle(color: AppColors.greyText),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
            ),
          )
        ],
      ),
    );
  }

  moveToScreen(Object? role) async {
    var r = role as Map;

    if (mtoken != r['token']) {
      var response = await UserCrud.updateUserToken(
          deviceToken: mtoken, phone: textEditingController.text);

      if (response.code != 200) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text('Some Error Occured'),
              );
            });

        return;
      }
    }

    if (mounted) {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            mobile: textEditingController.text,
            countrycode: "+91",
            userName: r['name'],
            role: r['role'],
          ),
        ),
      );
    }
  }

  continueClick() {
    if (textEditingController.text.length != 10) return;
    setState(() {
      loadingLogin = true;
    });
    Future<DocumentSnapshot> resp =
        UserCrud.readUser(phoneNum: textEditingController.text);

    resp.then(
      (doc) => {
        if (doc.data() == null)
          {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                      content: Text(
                    "Number Does not Exists! Please Regsiter",
                    textAlign: TextAlign.center,
                  ));
                }),
            setState(() {
              loadingLogin = false;
            })
          }
        else
          {moveToScreen(doc.data())}
      },
    );
  }
}
