import 'package:flutter/foundation.dart';

class CreateSummary {
  String url;

  CreateSummary({@required this.url});

  Map<String, dynamic> toJson() {
    return {"url": url};
  }
}
