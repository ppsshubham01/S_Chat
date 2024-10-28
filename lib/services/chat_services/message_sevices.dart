import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:s_chat/model/chats_models/message_model.dart';
import 'package:s_chat/widgets/comman.dart';

class MessageServices extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Send message with FCM notification
  Future<void> sendMessage(
      String receiverId, String message, String currentName) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return;

    String currentUserID = currentUser.uid;
    String currentUserEmail = currentUser.email ?? '';
    String currentUserName = currentUser.displayName ?? currentName;
    final timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
      senderName: currentUserName,
    );

    String chatRoomId = _getChatRoomId(currentUserID, receiverId);
    await fireStore.collection('chat_room').doc(chatRoomId).set({
      'last_message': message,
      'last_timestamp': timestamp,
    }, SetOptions(merge: true));

    await fireStore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    // Trigger FCM notification to the receiver
    await _sendFCMNotification(receiverId, message, currentUserName);
  }

  // Send FCM Notification to receiver's device
  Future<void> _sendFCMNotification(
      String receiverId, String message, String senderName) async {
    final receiverData =
        await fireStore.collection('users').doc(receiverId).get();
    if (!receiverData.exists || !receiverData.data()!.containsKey('fcmToken')) {
      return;
    }
    String? fcmToken = receiverData['fcmToken'];
    if (fcmToken == null) return;

    const String serverKey = 'YOUR_SERVER_KEY';
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: '''
      {
        "to": "$fcmToken",
        "notification": {
          "title": "$senderName sent a message",
          "body": "$message",
          "sound": "default"
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "senderID": "${_firebaseAuth.currentUser!.uid}"
        }
      }
      ''',
    );
  }

  // Helper function for chat room ID
  String _getChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  ///################################

  Stream<QuerySnapshot> getMessages(
      String userId, String otherUserId, String currentName) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomID = ids.join("_");

    return fireStore
        .collection('chat_room')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> deleteMessages(
      String userId, String otherUserId, String currentName) async {
    try {
      List<String> ids = [userId, otherUserId];
      ids.sort();
      String chatroomID = ids.join("_");

      await fireStore.collection('chat_room').doc(chatroomID).delete();
    } catch (error) {
      logger.e('message services ${error.toString()}');
    }
  }
}
