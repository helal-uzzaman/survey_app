import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/widget.dart';

class Question {
  String question;
  QuestionType questionType;
  List<String> options;
  Question(this.question, this.questionType, this.options);
  var answer;
}

enum QuestionType { multipleChoice, box, text }

class Survey extends StatefulWidget {
  Survey({Key? key}) : super(key: key);

  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  int _currentPosition = 0;
  late final List<Question> _questions;
  _SurveyState() {
    _questions = getQuestions();
  }
  @override
  Widget build(BuildContext context) {
    return (_currentPosition < _questions.length)
        ? Column(
            children: [
              QuestionWidget(_questions[_currentPosition].question),
              ...(_questions[_currentPosition].options).map((option) =>
                  OptionWidget(() => {submitAnswer(option)}, option))
            ],
          )
        : Column(children: [
            const Text("Congrats"),
            StyledButton(
              child: const Text("Submit"),
              onPressed: submitSurvey,
            )
          ]);
  }

  void submitAnswer(var answer) {
    _questions[_currentPosition].answer = answer;
    setState(() {
      _currentPosition++;
    });
  }

  // later change to store answer in database.
  void submitSurvey() async {
    print("Firebase current user: ${FirebaseAuth.instance.currentUser}");

    var _fbs = FirebaseFirestore.instance.collection("surveys");
    await _fbs.add({
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "name": FirebaseAuth.instance.currentUser!.displayName,
      "questions": _questions.map((e) => e.question).toList(),
      'questiontype': _questions.map((e) => e.questionType),
      "answers": _questions.map((e) => e.answer).toList(),
    });

    for (var element in _questions) {
      print(element.answer);
    }
  }

  // leter use database as source.
  List<Question> getQuestions() {
    // demo questions
    var questions = [
      Question(
        "How are you?",
        QuestionType.multipleChoice,
        ["fine", "ok", "bad"],
      ),
      Question("What is your sex?", QuestionType.multipleChoice,
          ["male", "femal", "other"]),
      Question(
        "What is your religion?",
        QuestionType.multipleChoice,
        ["muslim", "cristan", "hindu"],
      ),
      Question(
        "How are you?",
        QuestionType.multipleChoice,
        ["fine", "ok", "bad"],
      ),
      Question(
        "What is your country?",
        QuestionType.multipleChoice,
        ["Nepal", "Srilanka", "Bangladesh", "India"],
      ),
    ];
    return questions;
  }
}
