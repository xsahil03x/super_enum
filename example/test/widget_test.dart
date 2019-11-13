// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:example/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ignore: close_sinks
  final _controller = StreamController<Result<int>>();

  test('Sealed Class test', () async {
    final intStream = _controller.stream;

    getResult() async {
      for (int i = 0; i < 2; i++) {
        if (i == 0)
          _controller.add(Result.success(data: 333, message: 'Hurray'));
        else
          _controller.add(
              Result.error(exception: Exception('Some exception occured')));

        await Future.delayed(Duration(seconds: 1));
      }
    }

    intStream.listen((result) {
      result.when(
        onSuccess: (data) => print(data.message),
        onError: (data) => print(data.exception),
      );
    });

    await getResult();
  });
}
