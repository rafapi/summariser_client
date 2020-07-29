import 'package:flutter/material.dart';
import 'package:summariser_client/models/summary_listing.dart';

class SummaryList extends StatelessWidget {
  final summaries = [
    new SummaryListing(
        summaryId: "1",
        createDateTime: DateTime.now(),
        latestEditDateTime: DateTime.now(),
        summaryTitle: "Summary 1"),
    new SummaryListing(
        summaryId: "2",
        createDateTime: DateTime.now(),
        latestEditDateTime: DateTime.now(),
        summaryTitle: "Summary 2"),
    new SummaryListing(
        summaryId: "3",
        createDateTime: DateTime.now(),
        latestEditDateTime: DateTime.now(),
        summaryTitle: "Summary 3"),
  ];

  String formaDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: ListView.separated(
          separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Colors.green,
              ),
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(
                summaries[index].summaryTitle,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              subtitle: Text(
                  'Last edited on ${formaDateTime(summaries[index].latestEditDateTime)}'),
            );
          },
          itemCount: summaries.length),
    );
  }
}
