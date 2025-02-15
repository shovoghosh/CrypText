import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popup Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Popup Title'),
                  content: Text('This is the content of the popup.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // This line dismisses the dialog
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Show Popup'),
        ),
      ),
    );
  }
}
