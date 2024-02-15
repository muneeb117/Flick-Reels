import 'package:flutter/material.dart';
class ExportProgressScreen extends StatelessWidget {
  final double progress;

  const ExportProgressScreen({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exporting Video')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(value: progress),
            SizedBox(height: 20),
            Text('${(progress * 100).toStringAsFixed(0)}% Completed'),
          ],
        ),
      ),
    );
  }
}