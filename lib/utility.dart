import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utility{

  static var shared=Utility();

  String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');

  return "$hours:$minutes:$seconds";
}

showToast(String msg) =>
   Fluttertoast.showToast(msg: msg,gravity: ToastGravity.BOTTOM);


}

String formateDate(DateTime date)=>DateFormat('yyyy/MM/dd').format(date);