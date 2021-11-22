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
              ...(_questions[_currentPosition].options)
                  .map((option) => OptionWidget(() => {
                    submitAnswer(option)
                  }, option))
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
  void submitSurvey() {
    _questions.forEach((element) {
      print(element.answer);
    });
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
