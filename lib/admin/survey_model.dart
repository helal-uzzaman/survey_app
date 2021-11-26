class SurveyModel {
  String name;
  String email;
  // DateTime timeStamp;
  List<dynamic> questions;
  List<dynamic> answers;

  SurveyModel({
    required this.name,
    required this.email,
    required this.questions,
    required this.answers,
  });
}
