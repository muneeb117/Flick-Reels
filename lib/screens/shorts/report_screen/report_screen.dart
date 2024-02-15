import 'package:flick_reels/components/reusable_button.dart';
import 'package:flick_reels/utils/app_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/report_model.dart';

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
          title: Text('Report a Problem'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Why you are Reporting this video?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.h,
              ),
              ...reportReasons
                  .map((reason) => RadioListTile(
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
              TextField(
                controller: additonalTextController,
                decoration:
                    InputDecoration(labelText: "Additional details (optional)"),
                minLines: 1,
                maxLines: 5,
              ),
              SizedBox(
                height: 20.h,
              ),
              ReusableButton(
                text: "Submit Report",
                onPressed: _submitReport,
              )
            ],
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
    final report= Report(
      reportId: firestore.collection("reports").doc().id,
      videoId: widget.videoId,
      reason: selectedReason!,
      reportedDateTime: DateTime.now(),
      reportedByUserId: firebaseAuth.currentUser!.uid,
      additionalDetails: additonalTextController.text.toString(),
    );
    await firestore.collection("reports").doc(report.reportId).set(report.toJson());
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thank you for reporting. We will review it shortly.'))
    );
  }
}
