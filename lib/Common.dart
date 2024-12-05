import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget appButton(
    {required String buttonText,
    Function()? onPressed,
    Color bgColor = Colors.blue,
    double radius = 14}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      child: Center(
        child: Text(
          "${buttonText}",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ),
  );
}

showErrorMsg(String error,Color bg) {
  Fluttertoast.showToast(
      msg: "${error}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: bg,
      textColor: Colors.white,
      fontSize: 16.0);
}

showProgressDialog(BuildContext context) async {
  final alert = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    contentPadding: EdgeInsets.zero,
    insetPadding: EdgeInsets.symmetric(horizontal: 24),
    content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
          ],
        )),
  );

  showDialog(
    useRootNavigator: false,
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

hideProgress(BuildContext context) {
  Navigator.pop(context);
}

class Common {

  static List<String> imgList = [
    "asset/hydration.png",
    "asset/yoga.png",
    "asset/exercises.png",
    "asset/breakfast.png",
  ];

  static List<String> imgpList = [
    "asset/yoga.png",
    "asset/fruit.png",
    "asset/exercises.png",
    "asset/hydration.png",
  ];

  static List<String> strList = [
    "Hydration",
    "Yoga",
    "Exercises",
    "Breakfast",
  ];

  static List<String> subList = [
    "250 ml",
    "45 min",
    "30 min",
    "",
  ];

  static List<String> timerList = [
    "5:30 Am",
    "6:30 Am",
    "7:30 Am",
    "8:00 Am",
  ];

  static List<String> strPlanList = [
    "Yoga",
    "Fruits",
    "Exercises",
    "Hydration",
  ];

  static List<String> subPlanList = [
    "3 Type of Yoga",
    "2 Apple a Day",
    "8 Excercises",
    "6 Cups a Day",
  ];

  static List<Color> colorList = [
    Color(0xffc6edfd),
    Color(0xffafc4fa),
    Color(0xffffbeae),
    Color(0xfffeeda9),
  ];

  static List<Color> colorpList = [
  Color(0xffffd0c0),
  Color(0xfffec5cc),
  Color(0xffffe7db),
  Color(0xffc6edfc),
  ];

  static List<Icon> iconList = [
    Icon(
      Icons.radio_button_checked,
      color: Colors.black,
    ),
    Icon(
      Icons.radio_button_checked,
      color: Colors.grey,
    ),
    Icon(
      Icons.radio_button_checked,
      color: Colors.grey,
    ),
    Icon(
      Icons.radio_button_checked,
      color: Colors.grey,
    ),
  ];
}