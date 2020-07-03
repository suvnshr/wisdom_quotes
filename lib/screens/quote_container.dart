import 'package:flutter/material.dart';
import 'package:wisdom_quotes/helpers/fetch_quote.dart';
import 'package:wisdom_quotes/helpers/db_helper.dart';
import 'package:wisdom_quotes/widgets/about_icon_button.dart';
import 'package:wisdom_quotes/widgets/quote.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:wisdom_quotes/screens/quotes_list.dart';

import '../helpers/db_helper.dart';

// The main widget
class QuoteContainer extends StatefulWidget {
  @override
  _QuoteContainerState createState() => _QuoteContainerState();
}

class _QuoteContainerState extends State<QuoteContainer> {
  // > State Variables
  DatabaseHelper _db = DatabaseHelper.instance;
  String quoteKey = "";
  String quote = "";
  String author = "";
  String tag = "wisdom";
  bool isQuoteSaved = false;
  List<bool> _selections =
      [true] + List.generate(allTags.length - 1, (_) => false);

  // > Methods

  // save current quote to db
  void _insertIntoDb() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnQuoteKey: quoteKey,
      DatabaseHelper.columnName: author,
      DatabaseHelper.columnQuote: quote
    };

    await _db.insert(row);

    setState(() {
      isQuoteSaved = true;
    });
  }

  // remove current saved quote from db
  void _removeFromDb() async {
    await _db.deleteByKey(quoteKey);

    setState(() {
      isQuoteSaved = false;
    });
  }

  // if the quote is saved in db, then:
  //     `isQuoteSaved` state variable is set to true
  //      else it is set to false
  void setQuoteSaved(String quoteKey) async {
    List rows = await _db.rowsWithThisKey(quoteKey);

    if (rows.length > 0) {
      setState(() {
        isQuoteSaved = true;
      });
    } else {
      setState(() {
        isQuoteSaved = false;
      });
    }
  }

  // Stores the user preferred theme using shared preferences
  void setTheme(int themeModeInt) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("THEME", themeModeInt);
  }

  // this function is passed to `QuotesListScreen`
  // to reset the state when that screen is popped and the
  // user is navigated to `QuoteContainer`
  void resetState() {
    setQuoteSaved(quoteKey);
  }

  // load a random quote
  void loadQuote({String thisTag = "wisdom"}) async {
    // Set quote and author to empty to show the loading icon
    setState(() {
      quoteKey = quote = author = "";
    });

    // get new quote from the provided `tag`
    Map data = await getRandomQuote(tag: thisTag);

    // Set the new quote and auhtor as state
    setState(() {
      quoteKey = data['quoteKey'];
      quote = data['quote'];
      author = data['author'];
    });
    setQuoteSaved(quoteKey);
  }

  // change quote category tag
  void setNewTag(int newSelectedIndex, int previouslySelected) {
    // Only load new quote and change state if new selection is made
    if (newSelectedIndex != previouslySelected) {
      setState(() {
        tag = allTags[newSelectedIndex];
        _selections = List.generate(allTags.length, (_) => false);
        _selections[newSelectedIndex] = true;
      });

      loadQuote(thisTag: tag);
    }
  }

  // returns `CircularProgressIndicator`
  // if quote is not yet loaded or is empty
  Widget getStatusWidget() {
    if (quote == "" && author == "")
      return CircularProgressIndicator(
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
          IconButton(
            icon: Icon(Icons.turned_in),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuotesListScreen(resetState: resetState),
                ),
              );
            },
          ),
          AboutIconButton(),
        ],
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
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
                    allTags.length,
                    (int i) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          allTags[i],
                          style: TextStyle(
                            fontFamily: "Mali",
                          ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton.icon(
                      onPressed: () {
                        shareQuote(quote, author);
                      },
                      icon: Icon(Icons.share),
                      label: Text('Share'),
                      highlightedBorderColor: Colors.purple,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    OutlineButton.icon(
                      onPressed: isQuoteSaved ? _removeFromDb : _insertIntoDb,
                      icon: Icon(
                        isQuoteSaved ? Icons.turned_in : Icons.turned_in_not,
                      ),
                      label: Text(
                        isQuoteSaved ? "Saved" : "Save",
                      ),
                      highlightedBorderColor: Colors.purple,
                    )
                  ],
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
          semanticLabel: "Next quote",
        ),
      ),
    );
  }
}
