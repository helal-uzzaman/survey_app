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

enum QuestionType { singleChoice, multipleChoice, box, text }

class Survey extends StatefulWidget {
  Survey(this.signOut);
  // final ApplicationState surveyState;
  final void Function() signOut;
  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  int _currentPosition = 0;
  bool _submissionDone = false;
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
        : !_submissionDone
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  child: const Text("Submit"),
                  onPressed: () => {
                    submitSurvey((e) => {print("Data submission not worked.")})
                  },
                )
              ])
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Header("Thank you for completing the survey."),
                
                StyledButton(
                  child: const Text("LogOut"),
                  onPressed: widget.signOut,
                )
              ]);
  }

  void submitAnswer(var answer) {
    _questions[_currentPosition].answer = answer;
    setState(() {
      _currentPosition++;
    });
  }

  // later change to store answer in database. done
  void submitSurvey(
    void Function(Exception e) errorCallback,
  ) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    print("Firebase current user: ${FirebaseAuth.instance.currentUser}");
    try {
      var _fbsDocSurvey = FirebaseFirestore.instance
          .collection("surveys")
          .doc(currentUser!.uid);

      await _fbsDocSurvey.set({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "name": FirebaseAuth.instance.currentUser!.displayName,
        'email': FirebaseAuth.instance.currentUser!.email,
        "questions": _questions.map((e) => e.question).toList(),
        'questiontype':
            _questions.map((e) => e.questionType.toString()).toList(),
        "answers": _questions.map((e) => e.answer).toList(),
      });

      setState(() {
        _submissionDone = true;
      });
    } on Exception catch (e) {
      errorCallback(e);
    }
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
        QuestionType.singleChoice,
        ["fine", "ok", "bad"],
      ),
      Question("What is your sex?", QuestionType.singleChoice,
          ["male", "femal", "other"]),
      Question(
        "What is your religion?",
        QuestionType.singleChoice,
        ["muslim", "cristan", "hindu"],
      ),
      Question(
        "How are you?",
        QuestionType.singleChoice,
        ["fine", "ok", "bad"],
      ),
      Question(
        "What is your country?",
        QuestionType.singleChoice,
        ["Nepal", "Srilanka", "Bangladesh", "India"],
      ),
    ];
    return questions;
  }
}
