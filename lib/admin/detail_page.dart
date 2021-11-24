import 'package:flutter/material.dart';
import 'package:survey_app/admin/survey_model.dart';
import 'package:survey_app/survey.dart';
import 'package:survey_app/widget.dart';

class DetailsPage extends StatelessWidget {
  final SurveyModel survey;
  DetailsPage(this.survey) {
    init();
  }
  int itemCount = 0;

  void init() {
    itemCount = survey.questions.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Details"),
      ),
      body: Container(
        child: itemCount > 0
            ? ListView.builder(
                itemCount: itemCount,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Text(index.toString(),
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        title: Text(
                          survey.questions[index],
                        ),
                        
                      
                        subtitle: Text("Ans: ${survey.answers[index]}",
                          style:const TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  );
                },
              )
            : const Center(child: Text('No items')),
      ),
    );
  }
}
