import 'package:flutter/material.dart';

// The widget which renders the quote and author name
class Quote extends StatelessWidget {
  String quote;
  String author;

  Quote({this.quote, this.author});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          quote,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Mali",
          ),
        ),
        SizedBox(height: 20),
        Text(
          " - " + author,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Mali"),
        ),
      ],
    );
  }
}
