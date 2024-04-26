import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String senderID;
  String senderEmail;
  String senderName;
  String receiverID;
  String message;
  Timestamp timestamp;

  MessageModel(
      {required this.senderID, required this.senderEmail,required this.senderName, required this.receiverID, required this.message, required this.timestamp,});
  //covert to map

Map<String ,dynamic> toMap(){
  return {
    'SenderId' : senderID,
    'SenderEmail' : senderEmail,
    'SenderName' : senderName,
    'receiverId' : receiverID,
    'message' : message,
    'timestamp' : timestamp,
  };
}

}