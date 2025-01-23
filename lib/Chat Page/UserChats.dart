import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pingstar/Audio%20And%20Video%20Call/VideoCall.dart';
import 'package:pingstar/Images%20And%20Videos/imagesendingpage.dart';
import 'package:pingstar/Logged%20In%20Users/allchatspage.dart';
import 'package:pingstar/Multimedia%20Viewing%20Pages/Image_viewing.dart';
import 'package:pingstar/Utils/colors.dart';
import 'package:intl/intl.dart';
import 'dart:io';
class ChattingPage extends StatefulWidget {
  final String UserID;
  final String Name;

  const ChattingPage({super.key, required this.UserID, required this.Name});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => ImageSending(image: _image,otherUID: widget.UserID),));
    }
  }
  bool isonline = false;
  Future<void> getuseronlinestatus() async {
    final docRef =
        _firestore.collection('User Details(User ID Basis)').doc(widget.UserID);
    docRef.snapshots().listen((docsnap) {
      if (docsnap.exists) {
        setState(() {
          isonline = docsnap.data()?['User Online'];
        });

      }
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final currentUser = _auth.currentUser!;
      final timestamp = FieldValue.serverTimestamp();

      // Add message with 'pending' status
      final docRef = await _firestore.collection('chats').add({
        'senderID': currentUser.uid,
        'receiverID': widget.UserID,
        'message': message,
        'messageType':'text',
        'timestamp': timestamp,
        'status': 'pending',
      });

      // Update status to 'sent' after adding to Firestore
      await docRef.update({'status': 'sent'});
      await _firestore
          .collection('Recent Chats')
          .doc(_auth.currentUser!.uid)
          .set({
        'Other User UID': FieldValue.arrayUnion([widget.UserID])
      }, SetOptions(merge: true));
      await _firestore.collection('Recent Chats').doc(widget.UserID).set({
        'Other User UID': FieldValue.arrayUnion([_auth.currentUser!.uid])
      }, SetOptions(merge: true));
      _messageController.clear();
    }
  }
  Future<void> writeactivecalls()async{
    await _firestore.collection('Active Calls').doc(_auth.currentUser!.uid).set(
        {
          'User Busy':true
        });
  }
  @override
  void initState() {
    // TODO: implement initState
    getuseronlinestatus();
    print("Other User ID ${widget.UserID}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhatsAppColors.darkGreen,
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.Name,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                ),
                Text(
                  isonline ? 'online' : '',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.call, color: Colors.white),
              const SizedBox(width: 30),
              InkWell(
                onTap: () async {
                  await writeactivecalls();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCallPage(name: widget.Name, userId: widget.UserID, isInitiator: false)));
                },
                child: const Icon(Icons.video_call, color: Colors.white),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(12, 22, 28, 1.0),
      ),
      body: Stack(
        children: [
          // Chat messages list
      StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chats')
          .where('senderID', isEqualTo: _auth.currentUser!.uid)
          .where('receiverID', isEqualTo: widget.UserID)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot1.hasData || snapshot1.data!.docs.isEmpty) {
          return Container();
        }

        final messages1 = snapshot1.data!.docs;

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('chats')
              .where('senderID', isEqualTo: widget.UserID)
              .where('receiverID', isEqualTo: _auth.currentUser!.uid)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot2) {
            if (snapshot2.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot2.hasData || snapshot2.data!.docs.isEmpty) {
              return Container();
            }

            final messages2 = snapshot2.data!.docs;

            // Combine both message lists
            final combinedMessages = [
              ...messages1,
              ...messages2,
            ];

            // Sort the combined messages based on the timestamp
            combinedMessages.sort((a, b) => (b['timestamp'] as Timestamp).compareTo(a['timestamp']));

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: combinedMessages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = combinedMessages[index];
                final isCurrentUser = message['senderID'] == _auth.currentUser!.uid;

                final Timestamp? timestamp = message['timestamp'];
                final DateTime dateTime = timestamp != null ? timestamp.toDate() : DateTime.now();
                final formattedTime = DateFormat('hh:mm a').format(dateTime);

                final status = message['status'];
                final messageType = message['messageType'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isCurrentUser)
                            const CircleAvatar(
                              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                            ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              if (messageType == 'text')
                                Container(
                                  decoration: BoxDecoration(
                                    color: isCurrentUser ? Colors.green : Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      message['message'],
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              else if (messageType == 'image')
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Image_viewing(
                                          UserID: widget.UserID,
                                          Name: widget.Name,
                                          Image_Link: message['message'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[300],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(message['message'], fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    formattedTime,
                                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                  const SizedBox(width: 10),
                                  if (isCurrentUser)
                                    Icon(
                                      status == 'pending' ? CupertinoIcons.clock : status == 'sent' ? Icons.check : Icons.remove_red_eye,
                                      color: CupertinoColors.white,
                                      size: 12,
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          if (isCurrentUser)
                            const CircleAvatar(
                              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ),
    // Message typing section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              color: Colors.grey[900],
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                    onPressed: () {
                      // Handle attachment button press
                      _pickImage();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
