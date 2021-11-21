import 'dart:async';

import 'package:finalyearapp/answers.dart';
import 'package:finalyearapp/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Nanaue extends StatefulWidget {
  const Nanaue({Key key}) : super(key: key);

  @override
  _NanaueState createState() => _NanaueState();
}

class _NanaueState extends State<Nanaue> {
  List quest = [];
  Timer t;
  @override
  void initState() {
    super.initState();
    var j = 1;
    t = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      quest = await DatabaseServices().getquestions();
      if (j < 3) {
        setState(() {
          j++;
        });
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    t.cancel();
  }

  TextEditingController question = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff440099),
          title: Text(
            'Questions',
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
          children: List.generate(
              quest.length,
              (i) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      tileColor: Color(0xff440099).withOpacity(0.35),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        Answer(
                                          ques: quest[i],
                                        )));
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quest[i]['userID'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            quest[i]['question'],
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
                                'Answers : ${quest[i]["answers"]}',
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
                            hintText: 'Add a question',
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
                            await DatabaseServices().addQuestion(question.text);
                            print('done');
                            question.clear();
                            setState(() {});
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
