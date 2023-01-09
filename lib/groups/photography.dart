import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../widgets/sidebar_widget.dart';

class Photography extends StatefulWidget {
  String uname;
  Photography({required this.uname});

  @override
  State<Photography> createState() => _PhotographyState(uname: uname);
}

class _PhotographyState extends State<Photography> {
  String uname;
  _PhotographyState({required this.uname});
  final fs = FirebaseFirestore.instance;
  final TextEditingController message = new TextEditingController();
  final filter = ProfanityFilter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text('Photography'),
        backgroundColor: Colors.black12,
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
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    bool hasProfanity = filter.hasProfanity(message.text);
                    print('The string has profanity: $hasProfanity');
                    if (hasProfanity == true) {
                      message.text = filter.censor(message.text);
                    }
                    if (message.text.isNotEmpty) {
                      fs.collection('photography').doc().set({
                        'message': message.text.trim(),
                        'time': DateTime.now(),
                        'userName': uname,
                      });
                      message.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send_sharp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  messages({required String uname}) {
    final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
        .collection('photography')
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
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            primary: true,
            itemBuilder: (_, index) {
              QueryDocumentSnapshot qs = snapshot.data!.docs[index];
              Timestamp t = qs['time'];
              DateTime d = t.toDate();
              print(d.toString());
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: uname == qs['userName']
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: ListTile(
                        tileColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text(
                          qs['userName'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.purple,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                qs['message'],
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              d.hour.toString() + ":" + d.minute.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
