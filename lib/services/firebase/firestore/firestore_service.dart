import 'package:assosnation_app/services/interfaces/database_interface.dart';
import 'package:assosnation_app/services/models/association.dart';
import 'package:assosnation_app/services/models/conversation.dart';
import 'package:assosnation_app/services/models/post.dart';
import 'package:assosnation_app/services/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService extends DatabaseInterface {
  final FirebaseFirestore _service = FirebaseFirestore.instance;

  @override
  Future getAllConversations() {
    // TODO: implement getAllConversations
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getAllPostsByAssociation() async {
    CollectionReference posts = _service.collection("posts");
    try {
      QuerySnapshot snapshot = await posts.get();
      List<Post> postList = snapshot.docs
          .map((post) => Post(
              post.id,
              post.get('title'),
              post.get('assosId').toString(),
              post.get('likesNumber'),
              post.get('content'),
              post.get('photo'),
              post.get('timestamp').toDate()))
          .toList();
      return postList;
    } on FirebaseException catch (e) {
      return Future.error("Error while retrieving all posts");
    }
  }

  @override
  Future getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future addUserToDB(user) async {
    CollectionReference users = _service.collection("users");
    try {
      user as AnUser;

      await users.doc(user.uid).set({
        'firstName': user.firstName,
        'lastName': user.lastName,
        'mail': user.mail,
        'subscriptions': []
      });
    } on FirebaseException catch (e) {
      print("Error while adding user to database");
      print(e.message);
    }
  }

  @override
  Future<AnUser> getUserInfosFromDB(uid) async {
    CollectionReference _users = _service.collection("users");
    try {
      DocumentSnapshot snapshot = await _users.doc(uid).get();
      final _user = AnUser.withData(
          uid,
          snapshot.get('mail'),
          snapshot.get('firstName'),
          snapshot.get('lastName'),
          snapshot.get("subscriptions"));
      return _user;
    } on FirebaseException catch (e) {
      print(e.message);
      return Future.error("Error while retrieving all user data");
    }
  }

  @override
  Future removeUserFromDB(uid) {
    // TODO: implement removeUserFromDB
    throw UnimplementedError();
  }

  @override
  Future<List<Association>> getAllAssociations() async {
    CollectionReference associations = _service.collection("associations");
    try {
      QuerySnapshot snapshot = await associations.get();
      List<Association> assosList = snapshot.docs
          .map((e) => Association(
              e.id,
              e.get("name"),
              e.get("description"),
              e.get("mail"),
              e.get("address"),
              e.get("city"),
              e.get("postalCode"),
              e.get("phone"),
              e.get("banner"),
              e.get("president"),
              e.get("approved"),
              e.get("type"),
              e.get("posts"),
              e.get("actions"),
              e.get("subscribers")))
          .toList();
      return assosList;
    } on FirebaseException catch (e) {
      print(e.message);
      return Future.error("Error while retrieving all associations");
    }
  }

  @override
  Future addAssociationToDb(Association association) async {
    CollectionReference assos = _service.collection("associations");
    try {
      await assos.doc(association.uid).set({
        'name': association.name,
        'description': association.description,
        'president': association.president,
        'address': association.address,
        'city': association.city,
        'postalCode': association.postalCode,
        'phone': association.phone,
        'mail': association.mail,
        'banner': association.banner,
        'type': "",
        'posts': [],
        'actions': [],
        'subscribers': [],
        'approved':
            true // TODO need to change this after everything will be fine
      });
    } on FirebaseException catch (e) {
      print("Error while adding association to database");
      print(e.message);
    }
  }

  @override
  Future<List<Association>> getSubscribedAssociationByUser(String uid) async {
    CollectionReference associations = _service.collection("associations");
    try {
      final snapshot =
          await associations.where("subscribers", arrayContains: uid).get();
      List<Association> _subAssosList = snapshot.docs
          .map((e) => Association(
              e.id,
              e.get("name"),
              e.get("description"),
              e.get("mail"),
              e.get("address"),
              e.get("city"),
              e.get("postalCode"),
              e.get("phone"),
              e.get("banner"),
              e.get("president"),
              e.get("approved"),
              e.get("type"),
              e.get("posts"),
              e.get("actions"),
              e.get("subscribers")))
          .toList();
      return _subAssosList;
    } on FirebaseException catch (e) {
      print(e.message);
      return Future.error("Error while retrieving all associations");
    }
  }

  @override
  Future getAllConversationsByUser(AnUser user) async {
    CollectionReference _conversations = _service.collection("conversations");
    try {
      QuerySnapshot snapshot = await _conversations
          .where("participants", arrayContains: user.uid)
          .get();

      List<Conversation> conversationList = snapshot.docs
          .map((e) => Conversation(
              e.id, e.get("title"), e.get("messages"), e.get("participants")))
          .toList();
    } on FirebaseException catch (e) {
      print("Error while adding association to database");
      print(e.message);
    }
  }

  @override
  Future getAllMessagesByConversation(Conversation conversation) {
    // TODO: implement getAllMessagesByConversation
    throw UnimplementedError();
  }
}
