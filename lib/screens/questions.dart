import 'package:flutter/material.dart';
import 'package:quizizz_cheat/json/questions.dart';
import 'package:quizizz_cheat/json/questions_data/questions_info.dart';
import 'package:quizizz_cheat/json/questions_data/questions_structure.dart';
import 'package:quizizz_cheat/services/screen_config.dart';

class CustomSliverList extends StatelessWidget {
  const CustomSliverList({
    Key key,
    @required this.question,
  }) : super(key: key);

  final CoreData question;

  @override
  Widget build(BuildContext context) {
    int questionLength = question.data.quiz.info.questions.length;
    ScreenConfig().init(context);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, questionLength) {
          Structure structure =
              question.data.quiz.info.questions[questionLength].structure;

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.network(
                      (structure.query.media.isEmpty)
                          ? "https://moorestown-mall.com/noimage.gif"
                          : structure.query.media[0].url,
                      fit: BoxFit.cover,
                    ), // Image of the questions
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${questionLength + 1}. ${structure.query.text}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ), // Question's index
                    buildQuestionText(structure.options, structure.answer,
                        structure.kind, context), // The questions
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Type: ${structure.kind}",
                          style: TextStyle(fontSize: 13.0, color: Colors.blue),
                        ),
                        (structure.kind == "MSQ")
                            ? Text(
                                "Answers: ${(structure.answer).map((e) => e).toString()}",
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.red),
                              )
                            : Text("."),
                      ],
                    ), // Question's type and answer index
                  ],
                ),
              ),
            ),
          );
        },
        childCount: questionLength, //  Total number of questions
      ),
    );
  }

  Column buildQuestionText(List<QuestionText> option, dynamic answer,
      String kind, BuildContext context) {
    return Column(
      children: List.generate(
        option.length,
        (index) {
          return Container(
            width: screenWidth(1),
            margin: EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: (kind == "MCQ")
                  ? (answer != index)
                      ? Colors.redAccent
                      : Colors.greenAccent[700]
                  : Colors.blueAccent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ((option[index].text) != null)
                ? Text(
                    option[index].text,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  )
                : Image.network(
                    option[index].media[0]['url'],
                    fit: BoxFit.contain,
                  ),
          );
        },
      ),
    );
  }
}