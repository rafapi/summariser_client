class Summary {
  int summaryId;
  String summaryTitle;
  String summaryContent;
  DateTime createDateTime;

  Summary(
      {this.summaryId,
      this.summaryTitle,
      this.summaryContent,
      this.createDateTime});

  factory Summary.fromJson(Map<String, dynamic> item) {
    return Summary(
        summaryId: item['id'],
        summaryTitle: item['url'],
        summaryContent: item['summary'],
        createDateTime: item['created_at'] != null
            ? DateTime.parse(item['created_at'])
            : null);
  }
}
