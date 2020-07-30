import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:summariser_client/models/create_summary.dart';
import 'package:summariser_client/models/summary.dart';
import 'package:summariser_client/services/summary_service.dart';

class SummaryModify extends StatefulWidget {
  final String summaryId;
  SummaryModify({this.summaryId});

  @override
  _SummaryModifyState createState() => _SummaryModifyState();
}

class _SummaryModifyState extends State<SummaryModify> {
  bool get isEditing => widget.summaryId != null;

  SummariesService get summaryService => GetIt.I<SummariesService>();

  String errorMessage;
  Summary summary;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      summaryService.getSummary(widget.summaryId).then((response) {
        setState(() {
          _isLoading = false;
        });
        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
        summary = response.data;
        _titleController.text = summary.summaryTitle;
        _contentController.text = summary.summaryContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Summary' : 'Create Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Note title'),
                  ),
                  Container(
                    height: 8,
                  ),
                  TextField(
                    controller: _contentController,
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
                      onPressed: () async {
                        if (isEditing) {
                          // update note
                        } else {
                          final summary =
                              CreateSummary(url: _titleController.text);
                          final result =
                              await summaryService.createSummary(summary);
                          final title = 'Done';
                          final text = result.error
                              ? (result.errorMessage ?? 'An error occurred')
                              : 'Your summary has been created';
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: [
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ));
                        }
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
