import 'dart:io';
import 'dart:developer';

import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/model/messageModel.dart';
import 'package:chatapp/res/firebaseInstance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CheckUser {
  static User get user => Instances.auth.currentUser!;
  static late ChatUser info;
  static Future<bool> userExists() async {
    return (await Instances.firestore.collection('users').doc(user.uid).get())
        .exists;
  }

  static Future<void> selfInfo() async {
    await Instances.firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        info = ChatUser.fromMap(user.data()!);
      } else {
        await createUser().then((value) => getAllUser());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        uid: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey I am using Chat App!!",
        created_at: time,
        image: user.photoURL.toString(),
        is_online: false,
        last_active: time,
        push_token: '',
        is_pin: false,
        isblock: false,
        );
    return await Instances.firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return Instances.firestore
        .collection('users')
        .where('uid', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await Instances.firestore.collection('users').doc(user.uid).update({
      'name': info.name,
      'about': info.about,
    });
  }

  static Future<void> updateProfilePic(File file) async {
    final ext = file.path.split('.').last;
    final ref = Instances.store.ref().child('profile_pic/${user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
        (p0) => log('Data transferred: ${p0.bytesTransferred / 1000} kb'));
    info.image = await ref.getDownloadURL();
    await Instances.firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': info.image});
  }

  static String getConversatationid(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllmessage(
      ChatUser user) {
    return Instances.firestore
        .collection('chat/${getConversatationid(user.uid)}/message')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatuser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MessageModel message = MessageModel(
        fromid: user.uid,
        message: msg,
        read: '',
        sent: time,
        toid: chatuser.uid,
        type: type,
        isdelete: false,
        deleteother: false,
        isstar: false,
        
        );
    final ref = Instances.firestore
        .collection('chat/${getConversatationid(chatuser.uid)}/message/');
    await ref.doc(time).set(message.toMap());
  }

  static Future<void> updateMessageReadStatus(MessageModel message) async {
    Instances.firestore
        .collection('chat/${getConversatationid(message.fromid)}/message/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getlastmessage(
      ChatUser user) {
    return Instances.firestore
        .collection('chat/${getConversatationid(user.uid)}/message')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> unreadMessageCount(MessageModel message) async {
    Instances.firestore
        .collection('chat/${getConversatationid(message.fromid)}/message/')
        .doc(message.sent)
        .update({'read': FieldValue.increment(1)});
  }

  static Future<void> unreadCount(MessageModel message) async {
    Instances.firestore
        .collection('chat/${getConversatationid(message.fromid)}/message/')
        .doc(message.sent)
        .update({'read': FieldValue.increment(1)});
  }

  static Future<void> sentChatImage(ChatUser chatuser, File file) async {
    final ext = file.path.split('.').last;
    final ref = Instances.store.ref().child(
        'images/${getConversatationid(chatuser.uid)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
        (p0) => log('Data transferred: ${p0.bytesTransferred / 1000} kb'));
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatuser, imageUrl, Type.image);
    print("Image Url : $imageUrl");
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastSeenInfo(
      ChatUser chatuser) {
    return Instances.firestore
        .collection('users')
        .where('uid', isEqualTo: chatuser.uid)
        .snapshots();
  }

  static Future<void> activeStatusUpdate(bool isonline) async {
    Instances.firestore.collection('users').doc(user.uid).update({
      'is_online': isonline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  static Future<void> deleteMessage(MessageModel message) async {
    await Instances.firestore
        .collection('chat/${getConversatationid(message.toid)}/message/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await Instances.store.refFromURL(message.message).delete();
    }
  }

  static Future<void> updateMessage(
      MessageModel message, String updatedMessage) async {
    await Instances.firestore
        .collection('chat/${getConversatationid(message.toid)}/message/')
        .doc(message.sent)
        .update({'message': updatedMessage});
  }

  static Future<void> pinChat(ChatUser chatId) async {
    CollectionReference chatsCollection =
        Instances.firestore.collection('users');
    DocumentReference chatRef = chatsCollection.doc(chatId.uid);

    await chatRef.update({'is_pin': chatId.is_pin});
  }

  static Future<void> toggleIsPin(ChatUser user) async{
    user.is_pin=!user.is_pin;
    await pinChat(user);
  }
 

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPinnedChats() {
    return Instances.firestore
        .collection('users')
        .where('is_pin', isEqualTo: true)
        .snapshots();
  }

  static Future<List<ChatUser>> getUsersExceptCurrentUser() async {
    // Get a list of all users except the current user
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await getAllUser().first;

    // Convert the Firestore query snapshot to a list of ChatUser objects
    final List<ChatUser> users =
        snapshot.docs.map((doc) => ChatUser.fromMap(doc.data())).toList();

    // Filter out the current user
    users.removeWhere((users) => users.uid == user.uid);

    return users;
  }

  static void forwardMessage(ChatUser userToForward, MessageModel message) {
    // Copy the message and change the 'fromId' to the current user's ID
    final forwardedMessage = MessageModel(
        toid: userToForward.uid,
        message: message.message,
        read: '',
        type: message.type,
        fromid: user.uid,
        sent: DateTime.now().millisecondsSinceEpoch.toString(),
        isdelete: false,
        deleteother: false,
        isstar: false,
        
        );
        

    // Send the forwarded message
    sendMessage(userToForward, forwardedMessage.message, forwardedMessage.type);
  }

  static Future<bool> blockUser(String blockedUserId) async {
    try {
      // Get the current user's ID
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle the case where the user is not authenticated
        return false;
      }
      final currentUserId = currentUser.uid;

      // Update the current user's blockedUsers list with the blockedUserId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({
        'blockedUser': FieldValue.arrayUnion([blockedUserId]),
      });
      print(
          'User with ID $blockedUserId has been blocked by User with ID $currentUserId');
      return true;
    } catch (error) {
      print('Error blocking user: $error');
      return false;
    }
  }

// Function to unblock a user
  static Future<void> unblockUser(String unblockedUserId) async {
    try {
      // Get the current user's ID
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle the case where the user is not authenticated
        return;
      }
      final currentUserId = currentUser.uid;

      // Update the current user's blockedUsers list to remove the unblockedUserId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({
        'blockedUser': FieldValue.arrayRemove([unblockedUserId]),
      });

      print(
          'User with ID $unblockedUserId has been unblocked by User with ID $currentUserId');
    } catch (error) {
      print('Error unblocking user: $error');
    }
  }
  static Future<void> isblocked(ChatUser user) async {
    await Instances.firestore
        .collection('users')
        .doc(user.uid)
        .update({'isblock': true});
  }
  static Future<void> isunblock(ChatUser user) async {
    await Instances.firestore
        .collection('users')
        .doc(user.uid)
        .update({'isblock': false});
  }

  static Future<void> deleteForMe(MessageModel message) async {
    await Instances.firestore
        .collection('chat/${getConversatationid(message.toid)}/message/')
        .doc(message.sent)
        .update({'isdelete': true});
  }
  static Future<void> deleteForMeother(MessageModel message) async {
    await Instances.firestore
        .collection('chat/${getConversatationid(message.fromid)}/message/')
        .doc(message.sent)
        .update({'deleteother': true});
  }
  
  
  static Future<void> stared(MessageModel message) async {
    await Instances.firestore
        .collection('chat/${getConversatationid(message.fromid)}/message/')
        .doc(message.sent)
        .update({'isstar': true});
  }
  static Future<void> unstared(MessageModel message) async {
    await Instances.firestore
        .collection('chat/${getConversatationid(message.fromid)}/message/')
        .doc(message.sent)
        .update({'isstar': false});
  }
}
