import 'package:flutter/material.dart';

class SummaryModify extends StatelessWidget {
  final String summaryId;
  bool get isEditing => summaryId != null;
  SummaryModify({this.summaryId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Summary' : 'Create Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Note title'),
            ),
            Container(
              height: 8,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Note content'),
            ),
            Container(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
