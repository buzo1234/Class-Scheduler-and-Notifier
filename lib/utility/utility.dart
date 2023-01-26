import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

class Utility {
  static Widget loginButtonsWidget(String icon, String text, Function() onTap,
      Color borderColor, Color color, AppDimens appDimens, Color textColor,
      {EdgeInsetsGeometry? margin, double? borderRadius}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ??
            EdgeInsets.only(
              left: appDimens.paddingw16 * 2,
              right: appDimens.paddingw16 * 2,
              bottom: appDimens.paddingw10,
            ),
        decoration: BoxDecoration(
          color: color,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Colors.black54,
            ),
          ],
          border: Border.all(color: borderColor, width: 0.1),
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
        ),
        child: Container(
          padding: EdgeInsets.all(appDimens.paddingw10),
          child: Row(
            children: <Widget>[
              icon.trim().isEmpty
                  ? Container()
                  : Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: appDimens.paddingw10),
                      child: Image.asset(
                        icon,
                        height: appDimens.iconsize,
                        width: appDimens.iconsize,
                      ),
                    ),
              const Spacer(),
              Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: appDimens.text14,
                    color: textColor,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  static showToast({String msg = ''}) {
    Fluttertoast.showToast(msg: msg);
  }

  static Widget progress(BuildContext context, {Color? color}) {
    return Container(
      alignment: Alignment.center,
      color: color ?? Colors.transparent,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            backgroundColor: AppColors.blackColor.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.blackColor),
          ),
        ),
      ),
    );
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
