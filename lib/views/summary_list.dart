import 'package:flutter/material.dart';
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
        appBar: AppBar(
          title: Text('Article Summaries'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => SummaryModify()))
                .then((value) => _fetchSummaries());
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (_apiResponse.error) {
              return Center(
                child: Text(_apiResponse.errorMessage),
              );
            }
            return ListView.separated(
                separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.green,
                    ),
                itemBuilder: (_, index) {
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
                          message = 'The summary has been deleted successfully';
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
                      // print(result);

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
                itemCount: _apiResponse.data.length);
          },
        ));
  }
}
