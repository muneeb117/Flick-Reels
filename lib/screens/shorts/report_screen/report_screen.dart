import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/screens/script_generator/widgets/reusable_script_container.dart';
import 'package:flick_reels/utils/app_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/report_model.dart';
import '../../../utils/colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, required this.videoId});

  final String videoId;
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedReason;
  final TextEditingController additonalTextController = TextEditingController();
  final List<String> reportReasons = [
    "Nudity or Sexual Content",
    "Fraud or Scam",
    "Hate and Harassment",
    "Violence",
    "Spam or Misleading",
    "Child Abuse",

    // You can add more reasons specific to your platform's policies
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:   IconButton(onPressed:(){
          Navigator.of(context).pop();
        } , icon: Icon(Icons.arrow_back_ios_new,size: 20,)),
        title:    Text("Report A Problem ?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),

      ),
      backgroundColor: Colors.white,
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: AppColors.strokeColor,),

              SizedBox(
                height: 15.h,
              ),
              ...reportReasons
                  .map((reason) => RadioListTile(
                      activeColor: AppColors.primaryBackground,
                      title: Text(reason),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (String? value) {
                        setState(() {
                          selectedReason = value;
                        });
                      }))
                  .toList(),
              SizedBox(
                height: 20.h,
              ),
              ReusableScriptContainer(hintText: 'Give Details (optional)', child: null, controller: additonalTextController, maxLines: 3),
              // TextField(
              //   controller: additonalTextController,
              //   decoration: InputDecoration(
              //       labelText: "Additional details (optional)",
              //       border: OutlineInputBorder()),
              //   minLines: 3,
              //   maxLines: 10,
              // ),
              SizedBox(height: 120.h),
              ReusableButton(
                text: "Submit Report",
                onPressed: _submitReport,
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _submitReport() async {
    if (selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a reason for reporting"),
        ),
      );
      return;
    }
    final report = Report(
      reportId: firestore.collection("reports").doc().id,
      videoId: widget.videoId,
      reason: selectedReason!,
      reportedDateTime: DateTime.now(),
      reportedByUserId: firebaseAuth.currentUser!.uid,
      additionalDetails: additonalTextController.text.toString(),
    );
    await firestore
        .collection("reports")
        .doc(report.reportId)
        .set(report.toJson());
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Thank you for reporting. We will review it shortly.')));
  }
}
