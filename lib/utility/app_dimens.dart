import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DeviceType {
  ANDROIDPHONE,
  ANDROID7INCHTABLET,
  ANDROID10INCHTABLET,
  IOSIPAD3GEN, // WIDTH 834 HEIGHT 1112
  IOSIPADPRO12INCHTABLET, // WIDTH 1024
  IOSIPADPRO11INCHTABLET, // WIDTH 834 HEIGHT 1194
  IOSIPADPRO9INCHTABLET, // WIDTH 768
  IOSIPAD7, // WIDTH 810
  IOSDEVICE
}

class AppDimens {
  double text96 = 96.0;
  double text60 = 60.0;
  double text48 = 48.0;
  double text34 = 34.0;
  double text26 = 26.0;
  double text24 = 24.0;
  double text22 = 22.0;
  double text20 = 20.0;
  double text18 = 18.0;
  double text16 = 16.0;
  double text14 = 14.0;
  double text12 = 12.0;
  double text10 = 10.0;
  double text8 = 8.0;

  double button = 16.0;

  double paddingw2 = 2.0;
  double paddingw4 = 4.0;
  double paddingw6 = 6.0;
  double paddingw8 = 8.0;
  double paddingw10 = 10.0;
  double paddingw12 = 12.0;
  double paddingw14 = 14.0;
  double paddingw16 = 16.0;
  double paddingw18 = 18.0;
  double paddingw20 = 20.0;
  double paddingw22 = 22.0;
  double paddingw24 = 24.0;
  double paddingw26 = 26.0;
  double paddingw28 = 28.0;
  double paddingw30 = 30.0;

  double iconsize = 24;

  DeviceType deviceType = DeviceType.ANDROIDPHONE;
  AppDimens(Size size) {
    _getDevicetypes(size);
    _initSizes(size);
  }

  _initSizes(Size size) {
    double screenwidth = size.width;
    double screenheight = size.height;
    if ((screenwidth > 700)) {
      increasevalues(4.0, 4.0);
    } else if ((screenwidth >= 600 && screenwidth <= 700)) {
      increasevalues(2.0, 2.0);
    } else {
      increasevalues(0.0, 0.0);
    }
  }

  increasevalues(double textvalue, double paddingvalue) {
    text96 = 96.0 + textvalue;
    text60 = 60.0 + textvalue;
    text48 = 48.0 + textvalue;
    text34 = 34.0 + textvalue;
    text26 = 26.0 + textvalue;
    text24 = 24.0 + textvalue;
    text22 = 22.0 + textvalue;
    text20 = 20.0 + textvalue;
    text18 = 18.0 + textvalue;
    text16 = 16.0 + textvalue;
    text14 = 14.0 + textvalue;
    text12 = 12.0 + textvalue;
    text10 = 10.0 + textvalue;
    text8 = 8.0 + textvalue;

    button = 16.0 + textvalue;

    paddingw2 = 2.0 + paddingvalue;
    paddingw4 = 4.0 + paddingvalue;
    paddingw6 = 6.0 + paddingvalue;
    paddingw8 = 8.0 + paddingvalue;
    paddingw10 = 10.0 + paddingvalue;
    paddingw12 = 12.0 + paddingvalue;
    paddingw14 = 14.0 + paddingvalue;
    paddingw16 = 16.0 + paddingvalue;
    paddingw18 = 18.0 + paddingvalue;
    paddingw20 = 20.0 + paddingvalue;
    paddingw22 = 22.0 + paddingvalue;
    paddingw24 = 24.0 + paddingvalue;
    paddingw26 = 26.0 + paddingvalue;
    paddingw28 = 28.0 + paddingvalue;
    paddingw30 = 30.0 + paddingvalue;

    iconsize = 24;
  }

  _getDevicetypes(Size size) {
    double screenwidth = size.width;
    double screenheight = size.height;
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        if ((screenwidth >= 600 && screenwidth <= 700)) {
          deviceType = DeviceType.ANDROID7INCHTABLET;
        } else if ((screenwidth > 700)) {
          deviceType = DeviceType.ANDROID10INCHTABLET;
        } else {
          deviceType = DeviceType.ANDROIDPHONE;
        }
      } else if (Platform.isIOS) {
        if ((screenwidth >= 750 && screenwidth <= 800)) {
          deviceType = DeviceType.IOSIPADPRO9INCHTABLET;
        } else if ((screenwidth > 800 && screenwidth < 900)) {
          if (screenwidth == 810) {
            deviceType = DeviceType.IOSIPAD7;
          } else if (screenwidth == 834 && screenheight == 1194) {
            deviceType = DeviceType.IOSIPADPRO11INCHTABLET;
          } else if (screenwidth == 834 && screenheight == 1112) {
            deviceType = DeviceType.IOSIPAD3GEN;
          }
        } else if ((screenwidth > 1000)) {
          deviceType = DeviceType.IOSIPADPRO12INCHTABLET;
        } else {
          deviceType = DeviceType.IOSDEVICE;
        }
      }
    }
  }
}
