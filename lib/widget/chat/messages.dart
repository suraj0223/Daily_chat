import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:whatsapp/widget/chat/message_bubble.dart';
import 'package:http/http.dart';

class Messages extends StatefulWidget {
  final String chatRoomId;
  Messages(this.chatRoomId);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool isPlayingMsg = false, isRecording = false, isSending = false;
  ScrollController scrollController = ScrollController();
  AudioPlayer audioPlayer = AudioPlayer();


  Future _loadFile(String url) async {
    final bytes = await readBytes(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        recordFilePath = file.path;
        isPlayingMsg = true;
        print(isPlayingMsg);
      });
      await play(url);
      setState(() {
        isPlayingMsg = false;
      });
    }
  }

  void stopRecord() async {
    audioPlayer.stop();
    setState(() {
      isPlayingMsg = false;
    });
  }

  String recordFilePath;

  Future<void> play(String url) async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      await audioPlayer.play(
        recordFilePath,
        isLocal: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatRoom/${widget.chatRoomId}/chats')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          final List<DocumentSnapshot> chatDocs =
              chatSnapshot.hasData ? chatSnapshot.data.docs : null;

          if (chatSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if (chatSnapshot.hasData &&
              chatSnapshot.connectionState == ConnectionState.active)
            return ListView(
                reverse: true,
                children: chatDocs.map((message) {
                  bool isMe = message['userId'] ==
                      FirebaseAuth.instance.currentUser.uid;

                  if (message.data().toString().contains('type') == false) {
                    return MessageBubble(
                      username: message['createdBy'],
                      isMe: isMe,
                      // key: ValueKey(message.documentID),
                      cwidget: Text(
                        message['text'],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    );
                  }

                  return message['type'] == 'audio'
                      ? GestureDetector(
                          onTap: () {
                            _loadFile(message['audio']);
                          },
                          onSecondaryTap: () {
                            stopRecord();
                          },
                          child: MessageBubble(
                            isMe: isMe,
                            cwidget: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Icon(isPlayingMsg
                                    ? Icons.cancel
                                    : Icons.play_arrow),
                                Text(
                                  'Audio',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      : MessageBubble(
                          username: message['createdBy'],
                          isMe: isMe,
                          // key: ValueKey(message.documentID),
                          cwidget: Text(
                            message['text'],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            maxLines: 10,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            textAlign: isMe ? TextAlign.end : TextAlign.start,
                          ),
                        );
                }).toList());
          return Container();
        });
  }
}
