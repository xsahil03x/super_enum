import 'dart:async';

import 'package:flutter/material.dart';

import 'result.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sealed Class Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sealed Class Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _resultController = StreamController<Result<int>>();

  @override
  void dispose() {
    _resultController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<Result<int>>(
            stream: _resultController.stream,
            builder: (context, snapshot) {
              final result = !snapshot.hasError
                  ? snapshot.data?.when(
                        onSuccess: (success) =>
                            'Data: ${success.data}\nMessage: ${success.message}',
                        onError: (error) => error.exception,
                      ) ??
                      "No operation performed yet !"
                  : "Unknown error occurred";

              return Center(
                child: Text(
                  '$result',
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          SizedBox(height: 16.0),
          RaisedButton(
            onPressed: () => _resultController.add(Result.success(
              data: 333,
              message: 'Successfully Added',
            )),
            child: Text('Add Success State'),
          ),
          SizedBox(height: 16.0),
          RaisedButton(
            onPressed: () => _resultController.add(Result.error(
              exception: IntegerDivisionByZeroException(),
            )),
            child: Text('Add Error State'),
          ),
        ],
      ),
    );
  }
}
