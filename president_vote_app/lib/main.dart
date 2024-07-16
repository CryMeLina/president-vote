import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:president_vote_app/pages/candidat_page.dart';
import 'package:president_vote_app/pages/qr_page.dart';
import 'package:president_vote_app/pages/voting_result/bed_qr_code.dart';
import 'package:president_vote_app/pages/voting_result/error_voting.dart';
import 'package:president_vote_app/pages/voting_result/sucsessful_vote.dart';
import 'classes/Candidate.dart';
import 'feaches/qr_scanner.dart';
import 'package:firebase_core/firebase_core.dart';

//бутылочное горлышко, точка входа в программу
// следует отметить, для работы с базой данных мы используем именно асинхронное программирование
//т.к. нам будет необходимо постоянно возвращаться к общению с базой данных по мере выполнения функций
Future<void> main() async {
  // эти две строки инициализируют базу данных внутри нашего приложения

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

Future<List<Candidate>> convertDataSnapshotToList(
    DataSnapshot dataSnapshot) async {
  final Storage = FirebaseStorage.instance;

  List<Candidate> dataList = [];

  List<Object?> yourObject =
      dataSnapshot.value as List<Object?>; // получение объекта

  yourObject.forEach((element) {
    Map<dynamic, dynamic> a = element as Map<dynamic, dynamic>;
    dataList.add(Candidate.fromJson(a));
  });

  for (var element in dataList) {
    for (var picName in element.picture_name.split('#')) {
      final ref = Storage.ref().child(picName);
      final url = await ref.getDownloadURL();
      element.pictUrl.add(url);
    }
  }

  return dataList;
}

// класс который содержит нашу страницу, так же для него задаются основные свойства пейджа
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // прикольная булевая строка, она убирает надпись дебаг в правом верхнем углу
      debugShowCheckedModeBanner: false,
      title: 'Выборы Президента',

      // возвращаем виджет страницы
      home: const MyHomePage(),

      // прописываем роутсы для навигации по приложению
      routes: {
        '/qr_page': (context) => const QrCodePage(),
        '/qr_scanner': (context) => const QRScaner(),
        '/sucsessful_page': (context) => SucsessfulVotePage(),
        '/error_vote_page': (context) => ErrorVotePage(),
        '/bed_qrcode_page': (context) => BEDQRCodeVotePage(),
        '/candidate_page': (context) => CandidatePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
// создаем событие появления основного экрана под оверрайдом
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // переменная которая будет хранить ссылку на базу данных
  late String imageurl;

  late DataSnapshot snapshot;

  List<Candidate> candidates = [];
  //Запрос кандидатов из базы данных
  //Query dbRef = FirebaseDatabase.instance.ref().child("CandidatesDB");

//Создаем виджет странницы
  @override
  void initState() {
    super.initState();
    imageurl = '';
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    // final ref = Storage.ref().child('photo1696009403.jpeg');
    // final url = await ref.getDownloadURL();

    DatabaseReference refDB = FirebaseDatabase.instance.ref("CandidatesDB");

// Get the data once
    DatabaseEvent event = await refDB.once();

// Print the data of the snapshot
    //print(event.snapshot.value); // { "name": "John" }

    //snapshot = await FirebaseDatabase.instance.ref().child("CandidatesDB").get();
    // QuerySnapshot snapshot =
    //    await FirebaseFirestore.instance.collection('CandidatesDB').get();
    List<Candidate> loadedUsers =
        await convertDataSnapshotToList(event.snapshot);

    setState(() {
      candidates = loadedUsers;
      //imageurl = url;
    });
  }

  Widget listItem(int index) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      height: 150,
      child: // этот виджет позволяет ввести логику в виджет без логики
          GestureDetector(
        // при нажатии переходим на страницу
        onTap: () {
          Navigator.pushNamed(context, '/candidate_page', //candidat_screen
              arguments: candidates[index]);
        },
        // тут вся начинка, по сути это контейнер, внутри него строка, внутри строки два контейнера
        child: Container(
          height: 184,
          width: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.24),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Row(children: [
            Container(
              height: 300,
              width: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: NetworkImage('${candidates[index].pictUrl[0]}'),
                      fit: BoxFit.cover)),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      '${candidates[index].name}',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${candidates[index].age} лет, ${candidates[index].group} группа'),
                  ),
                  Text(
                    '${candidates[index].remarck}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      SizedBox(
        height: 50,
      ),
      Container(
          height: 130,
          width: MediaQuery.sizeOf(context).width,
          // декорация для контейнера
          decoration: BoxDecoration(color: Color.fromARGB(255, 174, 197, 255)),
          // создаем строку, конечно, можно использовать ListTitle, но я больше люблю строку
          child: Row(
            children: [
              //отступы
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                // контейнер логотипа птла, в форме круга
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  // столбец с двумя текстовыми виджетами
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      //текст 1
                      Text(
                        'Выборы ',
                        // декорируем
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(255, 134, 2, 2)),
                      ),
                      //текст 2
                      Text(
                        'Президента',
                        //декорируем
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(255, 134, 2, 2)),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
      Padding(
        padding: const EdgeInsets.only(top: 13.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Кандидаты',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
        ),
      ),
      Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: candidates.length,
              itemBuilder: (BuildContext context, int index) {
                return listItem(index);
              }))
    ]));
  }
}
