import 'package:flutter/material.dart';

class CheckupContent extends StatefulWidget {
  @override
  _CheckupContentState createState() => _CheckupContentState();
}

class _CheckupContentState extends State<CheckupContent> {
  String? selectedCheckupType;
  String? selectedLastCheckup;

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تنبيه"),
          content: const Text("الرجاء إعادة الفحص"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("حسناً"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
      child: Container(
        width: 450,
        height: 300,
        padding: EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 15),
              blurRadius: 25,
              color: Colors.black26,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedCheckupType == null) ...[
                const Text("نوع الفحص:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                RadioListTile<String>(
                  title: const Text("الشبكية"),
                  value: "الشبكية",
                  groupValue: selectedCheckupType,
                  onChanged: (value) =>
                      setState(() => selectedCheckupType = value),
                ),
                RadioListTile<String>(
                  title: const Text("الكلى"),
                  value: "الكلى",
                  groupValue: selectedCheckupType,
                  onChanged: (value) =>
                      setState(() => selectedCheckupType = value),
                ),
                RadioListTile<String>(
                  title: const Text("نوع آخر"),
                  value: "نوع آخر",
                  groupValue: selectedCheckupType,
                  onChanged: (value) =>
                      setState(() => selectedCheckupType = value),
                ),
              ] else ...[
                const Text("متى كان آخر فحص لك؟",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                RadioListTile<String>(
                  title: const Text("ثلاثة أشهر"),
                  value: "ثلاثة أشهر",
                  groupValue: selectedLastCheckup,
                  onChanged: (value) =>
                      setState(() => selectedLastCheckup = value),
                ),
                RadioListTile<String>(
                  title: const Text("ستة أشهر"),
                  value: "ستة أشهر",
                  groupValue: selectedLastCheckup,
                  onChanged: (value) =>
                      setState(() => selectedLastCheckup = value),
                ),
                RadioListTile<String>(
                  title: const Text("سنة"),
                  value: "سنة",
                  groupValue: selectedLastCheckup,
                  onChanged: (value) {
                    setState(() => selectedLastCheckup = value);
                    if (value == "سنة") {
                      _showAlertDialog();
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
