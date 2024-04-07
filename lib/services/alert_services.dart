import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'navigation_services.dart';

class AlertServices {
  final GetIt _getIt = GetIt.instance;

  late NavigationServices _navigationServices;

  //class constructor
  AlertServices() {
    _navigationServices = _getIt.get<NavigationServices>();
  }

  void showToast({required String text, IconData icon = Icons.info_outline}) {
    try {
      DelightToastBar(
          autoDismiss: true,
          snackbarDuration: Duration(milliseconds: 3000),
          animationDuration: Duration(milliseconds: 700),
          position: DelightSnackbarPosition.top,
          builder: (context) {
            return ToastCard(
              leading: Icon(icon),
              color: Colors.lightGreen,
              title: Text(text),
            );
          }).show(_navigationServices.navigatorStateKey!.currentContext!);
    } catch (e) {
      print(e);
    }
  }
}
