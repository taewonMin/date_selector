import 'package:date_selector/date_selector.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date Selector Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Date Selector Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DateTime _nowDate = DateTime.now();
  late String _startDate = DateTime(_nowDate.year - 7, _nowDate.month, _nowDate.day).toString().split(' ')[0];
  late String _endDate = DateTime(_nowDate.year, _nowDate.month, _nowDate.day).toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DateSelector(
              initDate: _startDate,
              onChangeFunction: (String value){
                setState(() {
                  _startDate = value.toString();
                });
              },
            ),
            const Text(' ~ '),
            DateSelector(
              initDate: _endDate,
              onChangeFunction: (String value){
                setState(() {
                  _endDate = value.toString();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
