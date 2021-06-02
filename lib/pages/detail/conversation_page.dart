import 'package:assosnation_app/components/messaging/send_message_form.dart';
import 'package:assosnation_app/services/firebase/firestore/firestore_service.dart';
import 'package:assosnation_app/services/models/conversation.dart';
import 'package:assosnation_app/services/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();

  final Conversation _conv;

  ConversationPage(this._conv);
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    final _user = context.watch<AnUser?>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation Title"),
        backwardsCompatibility: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: FutureBuilder(
              future: FireStoreService().getAllConversationsByUser(_user!),
              builder: (BuildContext build, AsyncSnapshot snapshots) {
                if (snapshots.hasData) {
                  switch (snapshots.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    case ConnectionState.done:
                      return ListView.builder(
                        itemCount: snapshots.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: ConversationPage(snapshots.data[index]),
                            ),
                          );
                        },
                      );
                    case ConnectionState.none:
                      return Container();
                      break;
                    case ConnectionState.active:
                      return CircularProgressIndicator();
                  }
                }
                if (snapshots.hasError) return Container();
                return Container();
              },
            ),
          ),
          Expanded(flex: 1, child: SendMessageForm()),
        ],
      ),
    );
  }
}
