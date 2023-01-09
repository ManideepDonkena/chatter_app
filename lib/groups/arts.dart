import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../widgets/sidebar_widget.dart';

class Arts extends StatefulWidget {
  String uname;
  Arts({required this.uname});

  @override
  State<Arts> createState() => _ArtsState(uname: uname);
}

class _ArtsState extends State<Arts> {
  String uname;
  _ArtsState({required this.uname});
  final fs = FirebaseFirestore.instance;
  final TextEditingController message = new TextEditingController();
  final filter = ProfanityFilter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Color.fromARGB(96, 194, 19, 19),
      appBar: AppBar(
        title: Text('Arts'),
        backgroundColor: Color.fromARGB(96, 194, 19, 19),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.79,
              child: messages(
                uname: uname,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextFormField(
                    controller: message,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () {
                    bool hasProfanity = filter.hasProfanity(message.text);
                    if (hasProfanity == true) {
                      message.text = filter.censor(message.text);
                    }
                    if (message.text.isNotEmpty) {
                      fs.collection('arts').doc().set({
                        'message': message.text.trim(),
                        'time': DateTime.now(),
                        'userName': uname,
                      });
                      message.clear();
                    }
                  },
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 28,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool colorset(uname, qs) {
    if (uname == qs['userName']) {
      return true;
    } else {
      return false;
    }
  }

  messages({required String uname}) {
    final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
        .collection('arts')
        .orderBy('time')
        .snapshots();
    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("something is wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              //child: CircularProgressIndicator(color: Colors.white70,),
              );
        }

        return SingleChildScrollView(
          reverse: true,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            primary: true,
            itemBuilder: (_, index) {
              QueryDocumentSnapshot qs = snapshot.data!.docs[index];
              Timestamp t = qs['time'];
              DateTime d = t.toDate();
              return Padding(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: uname == qs['userName']
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: ListTile(
                        tileColor: (colorset(uname, qs)
                            ? Colors.grey.shade200
                            : Colors.lightBlueAccent),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: (colorset(uname, qs)
                                ? Colors.grey.shade200
                                : Colors.lightBlueAccent),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          qs['userName'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                qs['message'],
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            Text(
                              d.hour.toString() + ":" + d.minute.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
