import 'dart:async';

import 'package:finalyearapp/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Answer extends StatefulWidget {
  const Answer({Key key, this.ques}) : super(key: key);
  final Map ques;
  @override
  _AnswerState createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  List quest = [];
  Timer t;
  @override
  void initState() {
    super.initState();
    var j = 1;
    t = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      quest = await DatabaseServices().getAnswers(widget.ques['id']);
      if (j < 3) {
        setState(() {
          j++;
        });
      }
    });
  }

  @override
  void deactivate() {
    t.cancel();
    super.deactivate();
  }

  TextEditingController question = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff440099),
          title: Text(
            'Answers',
            style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 18,
                fontWeight: FontWeight.w700),
          )),
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff7700ff), Color(0xff770077)]),
        ),
        child: ListView(
          children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    tileColor: Colors.white.withOpacity(0.35),
                    onTap: () {},
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.ques['userID'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.ques['question'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Likes : ${widget.ques["likes"]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Dislikes : ${widget.ques["dislikes"]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Answers : ${widget.ques["answers"]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'Answers',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ] +
              List<Widget>.generate(
                  quest.length,
                  (i) => Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          tileColor: Color(0xff440099).withOpacity(0.35),
                          onTap: () {},
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quest[i]['userid'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                quest[i]['answer'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Likes : ${quest[i]["likes"]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Dislikes : ${quest[i]["dislikes"]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Replies : ${quest[i]["replies"]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  elevation: 17,
                  title: Text(
                    '',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: question,
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 18,
                            ),
                            hintText: 'Add an answer',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Color(0xff7700ff).withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () async {
                          if (question.text != '') {
                            widget.ques['answers']++;
                            await DatabaseServices()
                                .addAnswer(question.text, widget.ques['id'],
                                    widget.ques['answers'])
                                .then((value) {
                              setState(() {});
                            });
                            setState(() {});
                            question.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ))
                  ],
                );
              });
        },
        backgroundColor: Color(0xff440099),
        child: Icon(
          Icons.add,
          color: Colors.white.withOpacity(0.65),
        ),
      ),
    );
  }
}
