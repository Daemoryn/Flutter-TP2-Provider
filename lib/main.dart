import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (_) => QuizCN(),
      child: Quiz(),
    ));

class Quiz extends StatefulWidget {
  @override
  QuizPage createState() => QuizPage();
}

final _messangerKey = GlobalKey<ScaffoldMessengerState>();

class QuizPage extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizCN>(context);

    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        appBar:
            AppBar(title: const Text('Questions/Réponses'), centerTitle: true),
        backgroundColor: Colors.black87,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Wrap(
                children: [
                  Score(
                      text: 'Tentatives : ',
                      textColor: Colors.yellow,
                      number: provider.tentatives),
                  Consumer<QuizCN>(builder: (context, variable, child) {
                    return Score(
                        text: 'Score : ',
                        textColor: Colors.white,
                        number: variable.score);
                  }),
                  Score(
                      text: 'Ancien score : ',
                      textColor: Colors.white60,
                      number: provider.scorePrecedent),
                ],
              ),
              provider.questions[provider.index],
              FadeInUp(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Choix(
                        text: 'Vrai',
                        primary: Colors.green,
                        function: () {
                          provider.checkAnswer(true, context);
                        }),
                    Choix(
                        text: 'Faux',
                        primary: Colors.red,
                        function: () {
                          provider.checkAnswer(false, context);
                        }),
                    Choix(
                        text: 'Passer',
                        primary: Colors.white24,
                        function: () {
                          provider.nextQuestion(false, context);
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizCN extends ChangeNotifier {
  List<Question> questions = [
    Question(
        url: 'images/zidane.jpg',
        text: 'La France a gagner la coupe du Monde 98.',
        isCorrect: true),
    Question(
        url: 'images/miel.jpg',
        text: 'Seul un aliment ne se déteriore jamais : le miel.',
        isCorrect: true),
    Question(
        url: 'images/langue.jpg',
        text: 'Le muscle le plus puissant du corps est la langue.',
        isCorrect: false)
  ];
  int index = 0;
  int score = 0;
  int scorePrecedent = 0;
  int tentatives = 0;

  void checkAnswer(bool userChoice, BuildContext context) {
    String text;
    bool flag;

    if (questions[index].isCorrect == userChoice) {
      text = 'Vous avez répondu juste !';
      flag = true;
    } else {
      text = 'Ce n\'est pas la bonne réponse :/';
      flag = false;
    }
    final snackBar = SnackBar(
        content: Center(child: Text(text, style: const TextStyle(fontSize: 20))),
        duration: const Duration(milliseconds: 1000));

    _messangerKey.currentState!.showSnackBar(snackBar);

    nextQuestion(flag, context);
  }

  void nextQuestion(bool flag, BuildContext context) {
    if (flag) {
      score++;
    }
    if (index < questions.length - 1) {
      index++;
      notifyListeners();
    } else {
      final snackBar = SnackBar(
          content: Center(
            child: Text(
                "C'est la fin du Quiz, vous avez un score de : " +
                    score.toString() +
                    " !",
                style: const TextStyle(fontSize: 20)),
          ),
          duration: const Duration(milliseconds: 2000));

      _messangerKey.currentState!.showSnackBar(snackBar);

      scorePrecedent = score;
      index = 0;
      score = 0;
      tentatives++;
      notifyListeners();
    }
  }
}

class Choix extends StatelessWidget {
  String text;
  double fontSize;
  Color primary;
  Color onPrimary;
  Function() function;

  Choix(
      {required this.text,
      this.fontSize = 50,
      required this.primary,
      this.onPrimary = Colors.black,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: primary, onPrimary: onPrimary),
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

class Question extends StatelessWidget {
  String url;
  double width;
  String text;
  Color? colorBackground;
  EdgeInsets? padding;
  double? textFontSize;
  Color? textColor;
  bool isCorrect;

  Question(
      {required this.url,
      this.width = 500.0,
      required this.text,
      this.colorBackground = Colors.black38,
      this.padding = const EdgeInsets.all(20.0),
      this.textFontSize = 20.0,
      this.textColor = Colors.white,
      required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: FadeInDown(
            child: Image.asset(
              url,
              width: width,
            ),
          ),
        ),
        FadeInUp(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              text,
              style: TextStyle(fontSize: textFontSize, color: textColor),
            ),
            color: colorBackground,
            padding: padding,
          ),
        ),
      ],
    );
  }
}

class Score extends StatelessWidget {
  String text;
  int? number;
  Color? colorBackground;
  EdgeInsets? padding;
  double? textFontSize;
  Color? textColor;

  Score(
      {required this.text,
      this.number = 0,
      this.colorBackground = Colors.black87,
      this.padding = const EdgeInsets.all(20.0),
      this.textFontSize = 20.0,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
        child: Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Text(text + number.toString(),
          style: TextStyle(fontSize: textFontSize, color: textColor)),
      color: colorBackground,
      padding: padding,
    ));
  }
}
