import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:summariser_client/models/create_summary.dart';
import 'package:summariser_client/models/summary.dart';
import 'package:summariser_client/services/summary_service.dart';
import 'package:summariser_client/services/url_launcher.dart';

class SummaryModify extends StatefulWidget {
  final String summaryId;
  SummaryModify({this.summaryId});

  @override
  _SummaryModifyState createState() => _SummaryModifyState();
}

class _SummaryModifyState extends State<SummaryModify> {
  bool get isReading => widget.summaryId != null;

  SummariesService get summaryService => GetIt.I<SummariesService>();

  String errorMessage;
  Summary summary;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isReading) {
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
        _urlController.text = summary.summaryUrl;
        _titleController.text = summary.summaryTitle;
        _contentController.text = summary.summaryContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isReading ? _titleController.text : 'Create Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (isReading)
                    Hyperlink(_urlController.text)
                  else
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(hintText: 'URL to summarise'),
                    ),
                  Container(
                    height: 8,
                  ),
                  SelectableText.rich(
                    TextSpan(
                      text: _contentController.text,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  if (!isReading)
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
                          setState(() {
                            _isLoading = true;
                          });
                          final summary =
                              CreateSummary(url: _urlController.text);
                          final result =
                              await summaryService.createSummary(summary);
                          setState(() {
                            _isLoading = false;
                          });
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
                                  )).then((data) {
                            if (result.data) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
