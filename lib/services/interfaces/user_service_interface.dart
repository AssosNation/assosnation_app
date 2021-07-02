import 'package:assosnation_app/services/models/association_action.dart';
import 'package:assosnation_app/services/models/user.dart';

abstract class UserServiceInterface {
  Future addUserToDB(user);

  Future<AnUser> getUserInfosFromDB(String uid);

  Future getAllUsers();

  Future updateUserProfileImg(String imgUrl);

  Future addUserToAction(AssociationAction action, _userId);

  Future removeUserToAction(AssociationAction action, _userId);

  Future addUsersToLikedList(String postId, AnUser user);

  Future removeUserToLikedList(String postId, AnUser user);

  Future<bool> checkIfUserIsAssos(String uid);

  Future removeUserFromDB(String uid);
}
