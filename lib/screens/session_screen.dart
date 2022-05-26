import 'package:flutter/material.dart';
import 'package:hello_flutter/data/session.dart';
import 'package:hello_flutter/data/sp_helper.dart';

class SessionScreen extends StatefulWidget {
  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  Iterable<Session> sessions = [];
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final SPHelper helper = SPHelper();

  @override
  void initState() {
    helper.init().then((value) {
      updateScreen();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your training Sessions')),
      body: ListView(
        children: getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showSessionDialog(context);
        },
      ),
    );
  }

  Future<dynamic> showSessionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Insert Training Session'),
          content: SingleChildScrollView(
            child: Column(children: [
              TextField(
                controller: txtDescription,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              TextField(
                controller: txtDuration,
                decoration: const InputDecoration(hintText: 'Duration'),
              ),
            ]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                txtDescription.text = '';
                txtDuration.text = '';
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(onPressed: saveSession, child: const Text('Save'))
          ],
        );
      },
    );
  }

  Future saveSession() async {
    DateTime now = DateTime.now();
    String today = "${now.year}-${now.month}-${now.day}";
    int id = helper.getCounter() + 1;
    Session newSession = Session(
        id, today, txtDescription.text, int.tryParse(txtDuration.text) ?? 0);
    helper.writeSession(newSession).then((_) {
      updateScreen();
      helper.setCounter();
    });
    txtDescription.text = '';
    txtDuration.text = '';
    Navigator.pop(context);
  }

  List<Widget> getContent() {
    return sessions
        .map((session) => Dismissible(
              key: UniqueKey(),
              onDismissed: (_) {
                helper.deleteSession(session.id).then((_) {
                  updateScreen();
                });
              },
              child: ListTile(
                title: Text(session.description),
                subtitle:
                    Text("${session.date} - duration ${session.duration} min"),
              ),
            ))
        .toList();
  }

  void updateScreen() {
    sessions = helper.getSessions();
    setState(() {});
  }
}
