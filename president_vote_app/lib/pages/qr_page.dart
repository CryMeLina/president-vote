import 'package:flutter/material.dart';
import 'package:president_vote_app/feaches/qr_scanner.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

//Создаем виджет странницы
  @override
  Widget build(BuildContext context) {
    //каркас
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: 400,
              child: const QRScaner(),
              // child: QRVeiw,
            )
          ],
        ),
      ),
    );
  }
}
