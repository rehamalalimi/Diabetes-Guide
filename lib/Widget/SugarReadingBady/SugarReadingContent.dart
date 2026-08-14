import 'package:flutter/material.dart';

class BloodSugarReading extends StatefulWidget {
  @override
  _BloodSugarReadingState createState() => _BloodSugarReadingState();
}

class _BloodSugarReadingState extends State<BloodSugarReading> {
  String? diabetesStatus;
  String? testType;
  TextEditingController valueController = TextEditingController();

  void goBack() {
    setState(() {
      if (testType != null) {
        testType = null;
      } else if (diabetesStatus != null) {
        diabetesStatus = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0,left: 10,right: 10),
      child: Container(
        width: double.infinity,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (diabetesStatus == null) ...[
              Text("هل انت مريض سكر؟", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => diabetesStatus = "نعم"),
                    child: Text("نعم"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => setState(() => diabetesStatus = "لا"),
                    child: Text("لا"),
                  ),
                ],
              ),
            ] else if (testType == null) ...[
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: goBack,
                  ),
                  Text("اختر نوع الفحص:", style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  RadioListTile(
                    title: Text("تراكمي"),
                    value: "تراكمي",
                    groupValue: testType,
                    onChanged: (value) => setState(() => testType = value ),
                  ),
                  RadioListTile(
                    title: Text("بين الواجبات"),
                    value: "بين الواجبات",
                    groupValue: testType,
                    onChanged: (value) => setState(() => testType = value ),
                  ),
                  RadioListTile(
                    title: Text("خمس ساعات"),
                    value: "خمس ساعات",
                    groupValue: testType,
                    onChanged: (value) => setState(() => testType = value),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: goBack,
                  ),
                  Text("أدخل قيمة الفحص:", style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "أدخل الرقم هنا",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم الفحص';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 100,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1c6ab1),
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 3.0,
                    ),
                    onPressed: () {},
                    child: Text('إرسال', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
