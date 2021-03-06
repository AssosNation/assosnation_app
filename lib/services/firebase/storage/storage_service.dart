import 'dart:io';

import 'package:assosnation_app/services/firebase/firestore/firestore_service.dart';
import 'package:assosnation_app/services/firebase/firestore/posts_service.dart';
import 'package:assosnation_app/services/firebase/firestore/user_service.dart';
import 'package:assosnation_app/services/interfaces/storage_interface.dart';
import 'package:assosnation_app/services/models/association.dart';
import 'package:assosnation_app/services/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService extends StorageInterface {
  FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String> getBannerByAssociation(String assosId) async {
    try {
      Reference ref =
          _storage.ref().child('associations_banners').child(assosId);
      final _imageUrl = await ref.getDownloadURL();
      return _imageUrl;
    } on FirebaseException catch (e) {
      return Future.error("Cannot find the default image url");
    }
  }

  @override
  Future<String> getDefaultAssocaitonBannerUrl() async {
    try {
      Reference ref = _storage
          .ref()
          .child('associations_banners')
          .child('default_assos.png');
      final _imageUrl = await ref.getDownloadURL();
      return _imageUrl;
    } on FirebaseException catch (e) {
      return Future.error("Cannot find the default image url");
    }
  }

  @override
  Future<String> getImageByPost(String _postId) async {
    try {
      Reference ref = _storage.ref().child('posts_images').child(_postId);
      final _imageUrl = await ref.getDownloadURL();
      return _imageUrl;
    } on FirebaseException catch (e) {
      return Future.error("Cannot find the default image url");
    }
  }

  Future<bool> _requestPhotoAccessPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    await Permission.photos.request();
    return await Permission.photos.status.isGranted;
  }

  @override
  Future uploadAndUpdateUserImage(AnUser user) async {
    final permissionGranted = await _requestPhotoAccessPermission();
    if (permissionGranted) {
      final _picker = ImagePicker();
      PickedFile? image = await _picker.getImage(source: ImageSource.gallery);

      if (image != null) {
        var file = File(image.path);
        final snapshot = await _storage
            .ref()
            .child('users_images/${user.uid}')
            .putFile(file);

        final imageUrl = await snapshot.ref.getDownloadURL();
        await UserService().updateUserProfileImg(user.uid, imageUrl);
        return Future.value(true);
      } else {
        return Future.error('No Path Received');
      }
    } else {
      return Future.error('Grant Permissions and try again');
    }
  }

  @override
  Future<String> getDefaultUserProfileImg() async {
    try {
      Reference ref =
          _storage.ref().child('users_images').child('default_avatar.png');
      final _imageUrl = await ref.getDownloadURL();
      return _imageUrl;
    } on FirebaseException catch (e) {
      return Future.error("Cannot find the default image url");
    }
  }

  @override
  Future<File> selectImageFromGallery() async {
    final permissionGranted = await _requestPhotoAccessPermission();

    if (permissionGranted) {
      final _picker = ImagePicker();
      PickedFile? image = await _picker.getImage(source: ImageSource.gallery);
      if (image != null)
        return File(image.path);
      else
        return Future.error('No Path Received');
    } else {
      return Future.error('Grant Permissions and try again');
    }
  }

  @override
  Future<String> uploadPostImageToStorage(File image, String postId) async {
    final snapshot =
        await _storage.ref().child('posts_images/$postId').putFile(image);
    String imgUrl = await snapshot.ref.getDownloadURL();
    await PostService().updatePostImageUrl(postId, imgUrl);
    return imgUrl;
  }

  Future uploadAndUpdateAssociationBanner(Association association) async {
    final permissionGranted = await _requestPhotoAccessPermission();

    if (permissionGranted) {
      final _picker = ImagePicker();
      PickedFile? image = await _picker.getImage(source: ImageSource.gallery);

      if (image != null) {
        var file = File(image.path);
        final snapshot = await _storage
            .ref()
            .child('associations_banners/${association.uid}')
            .putFile(file);

        final imageUrl = await snapshot.ref.getDownloadURL();
        await FireStoreService()
            .updateAssociationBanner(association.uid, imageUrl);
        return Future.value(true);
      } else {
        return Future.error('No Path Received');
      }
    } else {
      return Future.error('Grant Permissions and try again');
    }
  }

  @override
  Future<String> uploadAssociationImageToStorage(
      File image, String assosId) async {
    final snapshot = await _storage
        .ref()
        .child('associations_banners/$assosId')
        .putFile(image);
    String imgUrl = await snapshot.ref.getDownloadURL();
    await FireStoreService().updateAssociationBanner(assosId, imgUrl);
    return imgUrl;
  }
}
