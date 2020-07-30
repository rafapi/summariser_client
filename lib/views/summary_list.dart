import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:summariser_client/models/summary_listing.dart';
import 'package:summariser_client/services/summary_service.dart';
import 'package:summariser_client/views/summary_delete.dart';
import 'package:summariser_client/views/summary_modify.dart';

class SummaryList extends StatefulWidget {
  @override
  _SummaryListState createState() => _SummaryListState();
}

class _SummaryListState extends State<SummaryList> {
  SummariesService get service => GetIt.I<SummariesService>();
  List<SummaryListing> summaries = [];

  String formaDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    summaries = service.getSummariesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SummaryModify(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView.separated(
          separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Colors.green,
              ),
          itemBuilder: (_, index) {
            return Dismissible(
              key: ValueKey(summaries[index].summaryId),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {},
              confirmDismiss: (direction) async {
                final result = await showDialog(
                    context: context, builder: (_) => SummaryDelete());
                return result;
              },
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.only(left: 16),
                child: Align(
                  child: Icon(
                    Icons.auto_delete,
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              child: ListTile(
                title: Text(
                  summaries[index].summaryTitle,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                subtitle: Text(
                    'Last edited on ${formaDateTime(summaries[index].latestEditDateTime)}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          SummaryModify(summaryId: summaries[index].summaryId),
                    ),
                  );
                },
              ),
            );
          },
          itemCount: summaries.length),
    );
  }
}
