import 'package:assosnation_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String uid;
  List messages;
  List participants;
  List names;

  Conversation(this.uid, this.messages, this.participants, this.names);

  String getDiffTimeBetweenNowAndLastMessage() {
    if (messages.length > 0) {
      return Utils.getDiffTimeBetweenNowAndTimestamp(
          messages.last["timestamp"]);
    }

    return '';

    /// TODO I18N
  }

  String getLastMessageSent() {
    if (messages.length > 0)
      return messages.last["content"].toString();
    else
      return "";
  }

  String getLastMessageSender() {
    if (messages.length > 0) {
      final senderId = participants
          .indexWhere((parti) => parti.id == messages.last["sender"].id);
      return "${names[senderId]} : ";
    } else
      return "No messages yet";

    /// TODO I18N
  }

  DocumentReference getDocRefWithId(String id) {
    return participants.firstWhere((docRef) => docRef.id == id);
  }

  Future<String> getReceiverName(String id) async {
    DocumentReference docRef =
        participants.firstWhere((participant) => participant.id != id);
    final name = await docRef.get();
    if (name.data()!.containsKey("firstName"))
      return "${name.get("firstName")} ${name.get("lastName")}";
    else
      return name.get("name");
  }
}
