import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wisdom_quotes/helpers/db_helper.dart';

class QuotesListScreen extends StatefulWidget {
  final Function resetState;

  QuotesListScreen({
    this.resetState,
  });

  @override
  _QuotesListScreenState createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  final dbHelper = DatabaseHelper.instance;

  /// Used to share quote to different apps.
  void shareQuote(quote, author) => Share.share('$quote - $author');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Quotes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            widget.resetState();
          },
        ),
      ),
      body: FutureBuilder(
        future: dbHelper.queryAllRows(),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? snapshot.data.length != 0
                  ? ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 12,
                        );
                      },
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data[index];
                        return ListTile(
                          title: Text(item['quote']),
                          subtitle: Text(item['author']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                child: Icon(Icons.share),
                                onTap: () {
                                  shareQuote(item['quote'], item['author']);
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                child: Icon(Icons.delete_outline),
                                onTap: () {
                                  setState(() {
                                    dbHelper.delete(item['_id']);
                                  });

                                  // Show snackbar
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      elevation: 2,
                                      backgroundColor:
                                          Colors.purple[800].withOpacity(0.6),
                                      content: Text(
                                        "Quote deleted",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Mali",
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(child: Text('No saved quotes!'))
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
