import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wisdom_quotes/helpers/db_helper.dart';

class QuotesListScreen extends StatefulWidget {
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
      ),
      body: FutureBuilder(
        future: dbHelper.queryAllRows(),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? snapshot.data.length != 0
                  ? ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
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
                                width: 5,
                              ),
                              InkWell(
                                child: Icon(Icons.delete),
                                onTap: () {
                                  setState(() {
                                    dbHelper.delete(item['_id']);
                                  });
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
