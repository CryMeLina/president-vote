import 'package:flutter/material.dart';
import 'package:president_vote_app/feaches/qr_scanner.dart';

class ErrorVotePage extends StatelessWidget {
  //StatefulWidget
//   final Widget? child;
//   const ErrorVotePage({super.key, this.child});

//   @override
//   State<ErrorVotePage> createState() => _SucssesfulPage();
// }

// class _SucssesfulPage extends State<ErrorVotePage> {
//   @override
//   void initState() {
//     Future.delayed(Duration(seconds: 3), () {
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => (widget.child!)),
//           (route) => false);
//     });
//     super.initState();
//   }

//Создаем виджет странницы
  @override
  Widget build(BuildContext context) {
    //каркас
    return Scaffold(
      body: Center(
          child: Column(
        children: [
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
          SizedBox(
            height: 100,
          ),
          Text(
            'QRCode уже голосовал!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Icon(
            Icons.close,
            size: 150,
            color: Colors.red.shade800,
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text('вернуться на главную'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 134, 2, 2),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    minimumSize: Size(350, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17))),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      )),
    );
  }
}
