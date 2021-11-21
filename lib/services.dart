import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  String user = 'Sanket';

  Future addQuestion(String question) async {
    List ls = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: user)
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());
    String id = ls[0];
    await FirebaseFirestore.instance.collection('questions').add({
      'question': question,
      'userID': id,
      'answers': 0,
      'likes': 0,
      'dislikes': 0
    });
  }

  Future addAnswer(String ans, String questid, int anss) async {
    List ls = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: user)
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());
    String id = ls[0];
    await FirebaseFirestore.instance
        .collection('questions')
        .doc(questid)
        .update({'answers': anss});
    await FirebaseFirestore.instance.collection('answers').add({
      'questionid': questid,
      'userid': id,
      'answer': ans,
      'likes': 0,
      'dislikes': 0,
      'replies': 0
    });
  }

  Future getquestions() async {
    List users = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.map((e) => e.get('name')).toList());
    List usersid = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());
    List ques = await FirebaseFirestore.instance
        .collection('questions')
        .get()
        .then((value) => value.docs.map((e) {
              var val = e.data();
              String name = users[usersid.indexOf(val['userID'])];
              val['userID'] = name;
              val['id'] = e.id;
              return val;
            }).toList());
    return ques;
  }

  Future getAnswers(String id) async {
    List users = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.map((e) => e.get('name')).toList());
    List usersid = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());
    List ans = await FirebaseFirestore.instance
        .collection('answers')
        .where('questionid', isEqualTo: id)
        .get()
        .then((value) => value.docs.map((e) {
              var val = e.data();
              String name = users[usersid.indexOf(val['userid'])];
              val['userid'] = name;
              val['id'] = e.id;
              return val;
            }).toList());
    return ans;
  }
}
