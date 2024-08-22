import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool changeState = false;
  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  List<List<String>> matrix = [['', '', ''],
    ['', '', ''],
    ['', '', '']];
  int totalBoxesCompleted = 0;
  String winMessage="In Progress ...";
  int xWins = 0;
  int oWins = 0;
  int draw = 0;

  @override
  Widget build(BuildContext context) {

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.brown[400],
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.brown[200],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: const Text('Tic Tac Toe',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
          centerTitle: true,
          elevation: 20.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                    children: [
                      Text(
                          "Player Scores",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[400],
                          ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Player X",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                xWins.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 75),
                          Column(
                            children: [
                              Text(
                                "Draw",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                draw.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 75),
                          Column(
                            children: [
                              Text(
                                "Player O",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                oWins.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              Expanded(
                flex: 4,
                child: GridView.builder(

                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if(displayElement[index] != '' ||
                                  winMessage != 'In Progress ...'){
                                  return;
                                }
                                var indexCalc = ((index+1)*3);
                                String indexStr = indexCalc.toString().padLeft(2, '0');
                                int matrixIndexRow = int.parse(indexStr.substring(0,1));
                                int matrixIndexCol = index-(3*matrixIndexRow);
                                if(changeState) {
                                  displayElement[index] = "O";
                                  matrix[matrixIndexRow][matrixIndexCol]="O";
                                }
                                else {
                                  displayElement[index] = "X";
                                  matrix[matrixIndexRow][matrixIndexCol]="X";
                                }
                                totalBoxesCompleted++;
                                changeState = !changeState;
                                if(totalBoxesCompleted > 4){
                                  checkWinner(index, matrixIndexRow);
                                }

                              });

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Center(
                                child: Text(
                                  displayElement[index],
                                  style: TextStyle(color: Colors.white, fontSize: 35),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: 9,
                ),
              ),
              Container(
                color: Colors.white,
                child: Center(
                  heightFactor: 5,
                  child: BlinkText(
                    winMessage,
                    style: TextStyle(fontSize: 24.0, color: Colors.blue),
                    endColor: Colors.brown,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  FilledButton(
                      onPressed: () {
                        setState(() {
                          changeState = false;
                          displayElement = ['', '', '', '', '', '', '', '', ''];
                          totalBoxesCompleted = 0;
                          matrix = [['', '', ''],
                            ['', '', ''],
                            ['', '', '']];
                          winMessage = "In Progress ...";
                        });
                      },
                      style: flatButtonStyle,
                      child: const Text('Reset Board'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    },
                    style: flatButtonStyle,
                    child: const Text('Exit full screen'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
                    },
                    style: flatButtonStyle,
                    child: const Text('Full screen'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void checkWinner(int index, int matrixIndexRow){
    List<int> diagonalIndexes = [0,2,4,6,8];
    bool check = matrix[matrixIndexRow].every((e) {
      return e == displayElement[index];
    });

    if(!check){
      check = matrix.every((e) {
        return e[index%3] == displayElement[index];
      });
    }

    var winner =  displayElement[index];
    if(diagonalIndexes.contains(index)){
      var centerIndex = 4;
      if((displayElement[centerIndex] == displayElement[centerIndex+4]) &&
          (displayElement[centerIndex] == displayElement[centerIndex-4])
          || (displayElement[centerIndex] == displayElement[centerIndex+2]) &&
              (displayElement[centerIndex] == displayElement[centerIndex-2])){
        check = true;
      }
    }
    setState(() {
      if(check){
        winMessage = "Player $winner wins!!";
        if(winner == 'O'){
          oWins++;
        }else if(winner == 'X'){
          xWins++;
        }
      }
      if(totalBoxesCompleted == 9 && !check){
        winMessage = "No Body wins !!";
        draw++;
      }
    });
  }
}
