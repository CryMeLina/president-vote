import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:president_vote_app/classes/Candidate.dart';

import '../feaches/image_slider_corusel.dart';
import '../feaches/qr_scanner.dart';

class CandidatePage extends StatelessWidget {
  final dynamic arguments;

  CandidatePage({this.arguments});

  @override
  Widget build(BuildContext context) {
    final Candidate candidat =
        ModalRoute.of(context)?.settings.arguments as Candidate;
    //каркас
    return Scaffold(
      body: Center(
        //столбец с виджетами и основной версткой
        child: Column(
          children: [
            Container(
              height: 70,
              width: MediaQuery.sizeOf(context).width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 35,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              height: 130,
              width: MediaQuery.sizeOf(context).width,
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 174, 197, 255)),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/logo.png'),
                            fit: BoxFit.cover)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Выборы 2023',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 134, 2, 2),
                        ),
                      ),
                      Text(
                        'Президента',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 134, 2, 2),
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 200.0),
              child: ListTile(
                title: Text(
                  candidat.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 87, 158)),
                ),
                subtitle: Text(
                  '${candidat.age} лет, ${candidat.group} группа',
                  style: TextStyle(color: Color.fromARGB(255, 0, 87, 158)),
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            candidat.pictUrl.length < 2
                ? Container(
                    height: 210,
                    width: 340,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(candidat.pictUrl[0]),
                            fit: BoxFit.cover)),
                  )
                : ImageCorusel(
                    arguments: candidat,
                  ),
            // ImageCorusel(arguments: candidat),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                candidat.election_programm.replaceAll("/n", "\n"),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/qr_scanner', //candidat_screen
                        arguments: candidat.id);

                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => const QRScaner()));
                  },
                  child: Container(
                    width: 343,
                    height: 47,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 134, 2, 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.24),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Перейти к голосованию",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   actions: [
      //     Expanded(
      //       child: Align(
      //         alignment: FractionalOffset.centerLeft,
      //         child: IconButton(
      //           icon: Icon(Icons.arrow_back),
      //           onPressed: () => Navigator.pop(context),
      //           iconSize: 35,
      //           color: Colors.black,
      //         ),
      //       ),
      //     ),

      //   ],
      // ),
    );
  }

  // ...
}
