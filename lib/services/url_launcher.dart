import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends StatelessWidget {
  final String _url;

  Hyperlink(this._url);

  Future<void> _launchURL() async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text.rich(
        TextSpan(
          text: 'Source: ',
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: _url,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ))
          ],
        ),
      ),
      onTap: _launchURL,
    );
  }
}
