import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:s_chat/model/chats_models/message_model.dart';

class MessageServices extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send MSG

  Future<void> sendMessage(
      String receiverId, String message, String currentName) async {
    // get current user info
    String currentUserID = _firebaseAuth.currentUser!.uid.toString();
    String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    String currentUserName = _firebaseAuth.currentUser!.displayName.toString();
    final Timestamp timestamp = Timestamp.now();

    // get current new message
    MessageModel newMessage = MessageModel(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverId,
        message: message,
        timestamp: timestamp,
        senderName: currentUserName);

    // construct chat room id from curren user id and receiver id(sorted to ensure the uniqueness
    List<String> ids = [currentUserID, receiverId];
    ids.sort(); // sort the ids  (this is for chat room id are same for everyOne  for any pair of people
    String chatRoomId =
        ids.join('_'); // combin the ids in single line to identify

    // add new Message to DataBase
    await _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

//get MSG
  Stream<QuerySnapshot> getMessages(
      String userId, String otherUserId, String currentName) {
    //construct chatRoomid from user ids(sorted the ids ensure it to matches the id user when sending

    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomID = ids.join("_");

    return _firestore
        .collection('chat_room')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // // //delete MSG
  // Future<void> deleteMessages(
  //     String userId, String otherUserId, String currentName) {
  //   //construct chatRoomid from user ids(sorted the ids ensure it to matches the id user when sending
  //
  //   List<String> ids = [userId, otherUserId];
  //   ids.sort();
  //   String chatroomID = ids.join("_");
  //
  //   return _firestore.collection('messages').doc(chatroomID).delete();
  // }
Future<void> deleteMessages(String userId, String otherUserId, String currentName) async {

  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatroomID = ids.join("_");

   _firestore
      .collection('chat_room')
      .doc(chatroomID)
      .collection('messages').doc("VbcZXp80y2oYDMQ2iW88").delete().then(
         (doc) => print("Document deleted"),
     onError: (e) => print("Error updating document $e"),
   );
  // print('messagecollection$messagesCollection');
  // var snapsots = await messagesCollection.get();
  // for(var doc in snapsots.docs){
  //   await doc.reference.delete();
  // }
}


}
