import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Logged%20In%20Users/allchatspage.dart';
import 'package:pingstar/Utils/colors.dart';
import 'package:intl/intl.dart';

class ChattingPage extends StatefulWidget {
  final String UserID;
  final String Name;

  const ChattingPage({super.key, required this.UserID, required this.Name});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
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
        'timestamp': timestamp,
        'status': 'pending',
      });

      // Update status to 'sent' after adding to Firestore
      await docRef.update({'status': 'sent'});
      await _firestore.collection('Recent Chats').doc(_auth.currentUser!.uid).set(
          {
            'Other User UID':FieldValue.arrayUnion([
              widget.UserID
            ])
          },SetOptions(merge: true));
      await _firestore.collection('Recent Chats').doc(widget.UserID).set(
          {
            'Other User UID':FieldValue.arrayUnion([
              _auth.currentUser!.uid
            ])
          },SetOptions(merge: true));
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhatsAppColors.darkGreen,
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
            ),
            const SizedBox(width: 20),
            Text(
              widget.Name,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        actions: const [
          Row(
            children: [
              Icon(Icons.call, color: Colors.white),
              SizedBox(width: 30),
              Icon(Icons.video_call, color: Colors.white),
              SizedBox(width: 20),
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
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Check if snapshot has data and handle empty state
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container();
              }

              final messages = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isCurrentUser = message['senderID'] == _auth.currentUser!.uid;

                  // Format timestamp
                  final Timestamp? timestamp = message['timestamp'];
                  final DateTime dateTime = timestamp != null ? timestamp.toDate() : DateTime.now();
                  final formattedTime = DateFormat('hh:mm a').format(dateTime);


                  final status = message['status']; // Get the message status

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment:
                      isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isCurrentUser)
                              const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                              ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: isCurrentUser ? Colors.green : Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      message['message'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Show status icon
                                    if (isCurrentUser)
                                      Icon(
                                        status == 'pending'
                                            ? CupertinoIcons.clock:
                                        status=='delivered'?CupertinoIcons.checkmark_alt_circle_fill
                                            : Icons.check,
                                        color:status=='seen'?Colors.blue: CupertinoColors.white,
                                        size: 12,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            if (isCurrentUser)
                              const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                              ),
                          ],
                        ),
                      ],
                    ),
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
                    icon: const Icon(Icons.attach_file, color: Colors.white),
                    onPressed: () {
                      // Handle attachment button press
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
