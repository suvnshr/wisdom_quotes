import 'package:flutter/material.dart';
import 'package:wisdom_quotes/helpers.dart';
import 'package:wisdom_quotes/widgets/about_icon_button.dart';
import 'package:wisdom_quotes/widgets/quote.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';

// The main widget
class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  // > State Variables

  String quote = "";
  String author = "";
  String tag = "wisdom";
  List<bool> _selections =
      [true] + List.generate(TAGS.length - 1, (_) => false);


  // > Methods

  // Stores the user preferred theme using shared preferences
  void setTheme(int themeModeInt) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("THEME", themeModeInt);
  }

  void loadQuote({String thisTag = "wisdom"}) async {

    // Set quote and author to empty to show the loading icon
    setState(() {
      quote = author = "";
    });

    // get new quote from the provided `tag`
    Map data = await getRandomQuote(tag: thisTag);

    // Set the new quote and auhtor as state
    setState(() {
      quote = data['quote'];
      author = data['author'];
    });
  }

  // change quote category tag
  void setNewTag(int newSelectedIndex, int previouslySelected) {
    
    // Only load new quote and change state if new selection is made
    if (newSelectedIndex != previouslySelected) {
      setState(() {
        tag = TAGS[newSelectedIndex];
        _selections = List.generate(TAGS.length, (_) => false);
        _selections[newSelectedIndex] = true;
      });

      loadQuote(thisTag: tag);
    }
  }

  // returns `CircularProgressIndicator` 
  // if quote is not yet loaded or is empty
  Widget getStatusWidget() {
    if (quote == "" && author == "") return CircularProgressIndicator(
      strokeWidth: 1.2,
    );

    return Quote(
      quote: quote,
      author: author,
    );
  }
  
  // shows platform share sheet to share quote
  void shareQuote(quote, author) => Share.share('$quote - $author');

  void initState() {
    super.initState();
    loadQuote();
  }

  @override
  Widget build(BuildContext context) {

    // Load quote if not already loaded
    if (quote == "" && author == "") loadQuote(thisTag: tag);

    ThemeData currentTheme = Get.theme;

    // If the current theme is a light theme
    // then these settings will be used
    IconData themeSwitchIcon = Icons.wb_incandescent;
    ThemeMode themeToBeApplied = ThemeMode.dark;
    int themeToBeAppliedInt = 3;
    String themeToBeAppliedLabel = "Switch to Dark mode";

    if (currentTheme.brightness == Brightness.dark) {
      // If the current theme is a dark theme
      // then these settings will be used

      themeSwitchIcon = Icons.wb_sunny;
      themeToBeApplied = ThemeMode.light;
      themeToBeAppliedInt = 2;
      themeToBeAppliedLabel = "Switch to Day mode";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wisdom Quotes",
          style: TextStyle(fontFamily: "average-sans"),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              themeSwitchIcon,
              semanticLabel: themeToBeAppliedLabel,
            ),
            tooltip: themeToBeAppliedLabel,
            onPressed: () {
              // Change the theme
              Get.changeThemeMode(themeToBeApplied);

              // Store the current theme using Shared preferences
              // so that if the app relaunched,
              // currently selected theme is applied initially
              setTheme(themeToBeAppliedInt);
            },
          ),
          AboutIconButton(),
        ],
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ToggleButtons(
                  isSelected: _selections,
                  highlightColor: Colors.grey,
                  fillColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  selectedColor: Theme.of(context).accentColor,
                  selectedBorderColor: Theme.of(context).accentColor,
                  children: List.generate(
                    TAGS.length,
                    (int i) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          TAGS[i],
                          style: TextStyle(fontFamily: "Mali"),
                        ),
                      );
                    },
                  ),
                  onPressed: (int newSelectedIndex) {
                    int previouslySelected = _selections.indexOf(true);
                    setNewTag(newSelectedIndex, previouslySelected);
                  },
                ),
                SizedBox(height: 40),
                getStatusWidget(),
                SizedBox(
                  height: 30,
                ),
                OutlineButton.icon(
                  onPressed: () {
                    shareQuote(quote, author);
                  },
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                  highlightedBorderColor: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          loadQuote(thisTag: tag);
        },
        child: Icon(
          Icons.refresh,
          semanticLabel: "Refresh Quote",
        ),
      ),
    );
  }
}
