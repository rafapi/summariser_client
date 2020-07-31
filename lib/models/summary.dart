class Summary {
  int summaryId;
  String summaryUrl;
  String summaryTitle;
  String summaryContent;
  DateTime createDateTime;

  Summary(
      {this.summaryId,
      this.summaryUrl,
      this.summaryTitle,
      this.summaryContent,
      this.createDateTime});

  factory Summary.fromJson(Map<String, dynamic> item) {
    return Summary(
        summaryId: item['id'],
        summaryUrl: item['url'],
        summaryTitle: item['title'],
        summaryContent: item['summary'],
        createDateTime: item['created_at'] != null
            ? DateTime.parse(item['created_at'])
            : null);
  }
}
