import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigglio/model/models/post_model.dart';
import 'package:gigglio/model/models/user_details.dart';
import 'package:gigglio/model/utils/app_constants.dart';
import 'package:gigglio/services/auth_services.dart';
import 'package:gigglio/services/extension_services.dart';
import 'package:gigglio/view_models/controller/root_controller.dart';
import 'package:gigglio/view_models/routes/routes.dart';
import '../../../model/models/notification_model.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final AuthServices authServices = Get.find();
  final RootController _rootController = Get.find();
  final posts = FirebaseFirestore.instance.collection(FB.post);
  final users = FirebaseFirestore.instance.collection(FB.users);
  final noti = FirebaseFirestore.instance.collection(FB.noti);
  final storage = FirebaseStorage.instance;

  final commentContr = TextEditingController();
  final commentKey = GlobalKey<FormFieldState>();

  void toNotifications() => Get.toNamed(Routes.notifications);
  void toPost() => Get.toNamed(Routes.addPost);

  void likePost(String id, {required PostModel post}) async {
    final user = authServices.user.value!;
    posts.doc(id).update({
      'likes': post.likes.contains(user.id)
          ? FieldValue.arrayRemove([user.id])
          : FieldValue.arrayUnion([user.id]),
    });
  }

  void gotoProfile(String id) => Get.toNamed(Routes.gotoProfile, arguments: id);
  void gotoPost(String id) => Get.toNamed(Routes.gotoPost, arguments: id);
  void sendReq(String id) => _rootController.sendRequest(id);
  void acceptReq(String id) => _rootController.acceptRequest(id);
  void unfriend(String id) {}

  void postComment(String doc, {required UserDetails postAuthor}) async {
    if (!(commentKey.currentState?.validate() ?? false)) return;
    if (commentContr.text.isEmpty) return;
    final user = authServices.user.value!;
    final comment = CommentModel(
        author: user.id,
        title: commentContr.text,
        dateTime: DateTime.now().toJson());

    posts.doc(doc).update({
      'comments': FieldValue.arrayUnion([comment.toJson()])
    });
    commentKey.currentState?.reset();
    commentContr.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    if (postAuthor.friends.contains(user.id)) {
      final noti = NotiModel(
        from: user.id,
        to: postAuthor.id,
        postId: doc,
        dateTime: DateTime.now().toJson(),
        category: NotiCategory.comment,
      );
      this.noti.add(noti.toJson());
    }
  }

  void sharePost(String id) {
    //TODO: develop share mechanism.

    // Get.toNamed(Routes.gotoPost, arguments: id);
  }
}
