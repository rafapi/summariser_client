import 'dart:convert';

import 'package:summariser_client/models/api_response.dart';
import 'package:summariser_client/models/create_summary.dart';
import 'package:summariser_client/models/summary.dart';
import 'package:summariser_client/models/summary_listing.dart';
import 'package:http/http.dart' as http;

class SummariesService {
  static const url = 'http://10.0.0.105:8002';
//  static const API = 'desolate-stream-75858.herokuapp.com';

  Future<APIResponse<List<SummaryListing>>> getSummariesList() async {
    return await http.get(url + '/summaries/').then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final summaries = <SummaryListing>[];
        for (var item in jsonData) {
          summaries.add(SummaryListing.fromJson(item));
        }
        return APIResponse<List<SummaryListing>>(data: summaries);
      }
      return APIResponse<List<SummaryListing>>(
          error: true, errorMessage: 'An error occurred');
    }).catchError((_) => APIResponse<List<SummaryListing>>(
        error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<Summary>> getSummary(String summaryId) async {
    return await http.get(url + '/summaries/' + summaryId).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<Summary>(data: Summary.fromJson(jsonData));
      }
      return APIResponse<Summary>(
          error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
        APIResponse<Summary>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> createSummary(CreateSummary item) async {
    return await http
        .post(url + '/summaries/', body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }

  Future<APIResponse<bool>> deleteSummary(String summaryId) {
    return http.delete(url + '/summaries/' + summaryId).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: 'An error occurred'));
  }
}
