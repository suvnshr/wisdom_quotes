import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class AboutIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info_outline),
      onPressed: () {
        showDialog(
          context: context,
          child: AboutDialog(
            applicationIcon: Image(
              height: 50,
              width: 50,
              image: AssetImage("assets/app_icon.png"),
            ),
            applicationName: "Wisdom Quotes",
            applicationVersion: "v1.2",
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("✨ Quotes from"),
                  GestureDetector(
                    child: Text(
                      " Quotable",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      _launchURL("https://github.com/lukePeavey/quotable");
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Text("🖥️ Get the code at"),
                  GestureDetector(
                    child: Text(
                      " Github",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      _launchURL(
                          "https://github.com/suvansh-rana/wisdom_quotes");
                    },
                  ),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "✍️ Created by",
                  ),
                  GestureDetector(
                    child: Text(
                      " Suvansh",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () =>
                        _launchURL("https://www.github.com/suvansh-rana"),
                  ),
                ],
              ),
                Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "🎁 Thanks to our",
                  ),
                  GestureDetector(
                    child: Text(
                      " contributors !!",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () =>
                        _launchURL("https://github.com/suvansh-rana/wisdom_quotes/graphs/contributors"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
