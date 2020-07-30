import 'package:summariser_client/models/summary_listing.dart';

class SummariesService {
  List<SummaryListing> getSummariesList() {
    return [
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
  }
}
