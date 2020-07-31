class SummaryListing {
  final int summaryId;
  final String summaryTitle;
  final DateTime createDateTime;

  SummaryListing({this.summaryId, this.summaryTitle, this.createDateTime});

  factory SummaryListing.fromJson(Map<String, dynamic> item) {
    return SummaryListing(
        summaryId: item['id'],
        summaryTitle: item['url'],
        createDateTime: item['created_at'] != null
            ? DateTime.parse(item['created_at'])
            : null);
  }
}
