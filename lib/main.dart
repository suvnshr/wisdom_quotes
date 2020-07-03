import 'package:flutter/material.dart';
import 'package:wisdom_quotes/screens/quote_container.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/theme_defaults.dart';

void main() => runApp(QuoteApp());


// The root widget
class QuoteApp extends StatefulWidget {
  @override
  _QuoteAppState createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {


  // Returns the theme mode users have choosen, 
  // defaults to system settings   
  Future<ThemeMode> getUserChoosenTheme() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int themeModeInt =
        prefs.getInt("THEME") ?? 1; // Return system theme as default

    ThemeMode userChoosenThemeMode = themeMap[themeModeInt];

    return userChoosenThemeMode;
  }

  // Set initial theme to the user choosen theme, when the app renders initially
  void setInitialThemeMode() async {
    ThemeMode userChoosenTheme = await getUserChoosenTheme();

    Get.changeThemeMode(userChoosenTheme);
  }

  void initState() {
    super.initState();
    setInitialThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wisdom Quotes',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple,
        fontFamily: "average-sans",
        accentColor: Colors.purple,
        buttonColor: Colors.purple,
        buttonTheme: ButtonThemeData(colorScheme: ColorScheme.light(primary: Colors.purple))
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.purpleAccent,
        fontFamily: "average-sans",
        buttonColor: Colors.purpleAccent,
      ),
      home: QuoteContainer(),
    );
  }
}
