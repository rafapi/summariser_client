import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:summariser_client/models/api_response.dart';
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
  APIResponse<List<SummaryListing>> _apiResponse;
  bool _isLoading = false;

  int get numSummaries {
    return _apiResponse?.data?.length ?? 0;
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchSummaries();
    super.initState();
  }

  _fetchSummaries() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getSummariesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      // backgroundColor: Colors.white,
      SliverAppBar(
        forceElevated: true,
        floating: true,
        pinned: true,
        expandedHeight: 100.0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(builder: (_) {
          return Center(
              child: Text(
            numSummaries.toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ));
        }),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Article Summaries',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Summary',
            iconSize: 30.0,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SummaryModify()))
                  .then((value) => _fetchSummaries());
            },
          )
        ],
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (_apiResponse.error) {
              return Center(
                child: Text(_apiResponse.errorMessage),
              );
            }
            return Container(
              margin: EdgeInsets.all(8.0),
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 6.0),
                ],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Builder(
                builder: (_) {
                  return Dismissible(
                    key: ValueKey(_apiResponse.data[index].summaryId),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      final result = await showDialog(
                          context: context, builder: (_) => SummaryDelete());
                      if (result) {
                        final deleteResult = await service.deleteSummary(
                            _apiResponse.data[index].summaryId.toString());
                        print(_apiResponse.data[index].summaryId);
                        setState(() {
                          _apiResponse.data.removeAt(index);
                        });
                        var message;
                        if (deleteResult != null && deleteResult.data == true) {
                          message = 'Summary deleted successfully';
                          // print(deleteResult.data);
                        } else {
                          message =
                              deleteResult?.errorMessage ?? 'An error occurred';
                        }
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Done'),
                                  content: Text(message),
                                  actions: [
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ));
                        return deleteResult?.data ?? false;
                      }
                      return result;
                    },
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        _apiResponse.data[index].summaryTitle,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      subtitle: Text(
                          'Created on ${formatDateTime(_apiResponse.data[index].createDateTime)}'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SummaryModify(
                                summaryId: _apiResponse.data[index].summaryId
                                    .toString()),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
          childCount: numSummaries,
        ),
      )
    ]));
  }
}
