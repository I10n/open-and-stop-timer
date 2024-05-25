import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tick Tack Tick Tack...'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("STOP"),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NextPage()));
          },
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Setting '),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("START"),
          onPressed: () {
            // ここにボタンを押した時に呼ばれるコードを書く
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
