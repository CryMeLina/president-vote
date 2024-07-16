import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScaner extends StatefulWidget {
  const QRScaner({super.key});

  @override
  State<QRScaner> createState() => _QRScanerState();
}

class _QRScanerState extends State<QRScaner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  int votingResult = -1;
  int indexCand = 0;
  bool execute = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  Future<void> getVoiting(String? qrCod, int index) async {
    DatabaseReference refDB =
        FirebaseDatabase.instance.ref("ElectionDB/" + qrCod!);

    try {
      DatabaseEvent event = await refDB.once();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> yourObject =
            event.snapshot.value as Map<dynamic, dynamic>;

        bool reg = false;
        if (!yourObject['IsValid']) {
          reg = true;
        }

        // yourObject.forEach((element) {
        //   Map<dynamic, dynamic> a = element as Map<dynamic, dynamic>;

        // });

        if (reg) {
          //DatabaseReference ref = FirebaseDatabase.instance.ref("ElectionDB/" + qrCod);

          await refDB.update({"Chose": index, "IsValid": true});
          votingResult = 200;
        } else {
          votingResult = 404;
        }
      } else {
        votingResult = 500;
      }
    } on Exception catch (_) {
      votingResult = 500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int indexVote = ModalRoute.of(context)?.settings.arguments as int;
    indexCand = indexVote;

    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 50,
        ),
        Container(
            height: 130,
            width: MediaQuery.sizeOf(context).width,
            // декорация для контейнера
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 174, 197, 255)),
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
        Expanded(
            child: QRView(
          key: qrKey,
          onQRViewCreated: onQRVeiwCamera,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.white,
            borderRadius: 10,
            borderLength: 20,
            borderWidth: 5,
            cutOutSize: 300,
          ),
        )),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: 70,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Наведите камеру на QRcode',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 134, 2, 2)),
            ),
          ),
        )
      ]),
    );
  }

  void onQRVeiwCamera(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (result != null) {
        if (execute) {
          execute = false;
          await getVoiting(result?.code, indexCand);
          if (votingResult == 200) {
            Navigator.pushNamed(context, '/sucsessful_page');
          } else {
            if (votingResult == 500) {
              Navigator.pushNamed(context, '/bed_qrcode_page');
            } else {
              Navigator.pushNamed(context, '/error_vote_page');
            }
          }
          //execute = true;
        }
      }
      if (votingResult == -1) {
        setState(() {
          result = scanData;
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
