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
            applicationIcon: ImageIcon(
              new AssetImage("assets/icon.png"),
            ),
            applicationName: "Wisdom Quotes",
            applicationVersion: "v1.0",
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Get the code"),
                  GestureDetector(
                    child: Text(
                      " here",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      _launchURL("https://www.github.com");
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Created by ",
                  ),
                  GestureDetector(
                    child: Text(
                      " Suvansh Rana",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () => _launchURL("https://www.github.com/suvansh-rana"),
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
