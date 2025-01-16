import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Chat%20Page/UserChats.dart';
import 'package:pingstar/Contact%20Page/AllContacts.dart';
import 'package:pingstar/Utils/colors.dart';

class AllChats extends StatefulWidget {
  const AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> contactname = []; // List to store contact names
  List<String> contactnumber = []; // List to store contact numbers
  String usercontactnumber = '';

  // Fetch user contact number
  Future<void> getcontactnumber() async {
    final docsnap = await _firestore
        .collection('User Details(User ID Basis)')
        .doc(_auth.currentUser!.uid)
        .get();
    try {
      if (docsnap.exists) {
        setState(() {
          usercontactnumber = docsnap.data()?['Mobile Number'];
        });
      }
      print('Number $usercontactnumber');
    } catch (e) {
      print(e);
    }
  }

  // Update user online status to true
  Future<void> updateactivity() async {
    try {
      await getcontactnumber();
      await _firestore
          .collection('User Details(User ID Basis)')
          .doc(_auth.currentUser!.uid)
          .update({
        'User Online': true,
      });
      await _firestore
          .collection('User Details(Contact Number Basis)')
          .doc(usercontactnumber)
          .update({
        'User Online': true,
      });
    } catch (e) {
      print(e);
    }
  }

  // Update user online status to false when app goes to background or is closed
  Future<void> setUserOffline() async {
    try {
      await getcontactnumber();
      await _firestore
          .collection('User Details(User ID Basis)')
          .doc(_auth.currentUser!.uid)
          .update({
        'User Online': false,
      });
      await _firestore
          .collection('User Details(Contact Number Basis)')
          .doc(usercontactnumber)
          .update({
        'User Online': false,
      });
    } catch (e) {
      print(e);
    }
  }

  // Optimized contact fetching method using flutter_contacts
  Future<void> getContacts() async {
    try {
      // Request permission if not granted
      if (await FlutterContacts.requestPermission()) {
        // Fetch contacts from device
        List<Contact> contacts =
            await FlutterContacts.getContacts(withProperties: true);

        // Extract contact names and phone numbers
        List<String> names = [];
        List<String> numbers = [];

        for (var contact in contacts) {
          String name = contact.displayName ?? 'Unnamed Contact';
          String phoneNumber = contact.phones.isNotEmpty
              ? contact.phones.first.number ?? 'No phone number'
              : 'No phone number';

          names.add(name);
          numbers.add(phoneNumber);
        }

        // Update the state once all contacts are fetched
        setState(() {
          contactname = names;
          contactnumber = numbers;
        });
        if (kDebugMode) {
          // print('name: $names contact number $contactnumber');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch contacts: $e');
      }
    }
  }

  List<String> ContactNumber = [];
  List<String> ContactName = [];
  List<String> OtherUserUIDS = [];
  String mobileNumber = '';
  List<String> lastMessages = [];
  List<String> lastMessagesstatus = [];

  Future<void> getrecentchats() async {
    await getContacts();

    final docsnap = await _firestore
        .collection('Recent Chats')
        .doc(_auth.currentUser!.uid)
        .get();
    if (docsnap.exists) {
      OtherUserUIDS =
          List<String>.from(docsnap.data()?['Other User UID'] ?? []);
    }

    for (int i = 0; i < OtherUserUIDS.length; i++) {
      final UserSnap = await _firestore
          .collection('User Details(User ID Basis)')
          .doc(OtherUserUIDS[i])
          .get();
      if (UserSnap.exists) {
        setState(() {
          mobileNumber = UserSnap.data()?['Mobile Number'] ?? '';
          String normalizedMobileNumber = normalizePhoneNumber(mobileNumber);
          ContactNumber.add(normalizedMobileNumber);
        });
      }
    }

    for (int i = 0; i < ContactNumber.length; i++) {
      String normalizedContactNumber = normalizePhoneNumber(contactnumber[i]);

      if (ContactNumber[i] == contactnumber[i]) {
        ContactName.add(contactname[i]);
      } else {
        ContactName.add(mobileNumber);
      }

      // Fetch last message from chats collection
      final lastMessageSnap = await _firestore
          .collection('chats')
          .where('senderID', isEqualTo: _auth.currentUser!.uid)
          .where('receiverID', isEqualTo: OtherUserUIDS[i])
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (lastMessageSnap.docs.isNotEmpty) {
        setState(() {
          // You can add this last message to a list to display in the chat list
          String lastMessage = lastMessageSnap.docs.first['message'] ?? '';
          String lastMessagests = lastMessageSnap.docs.first['status'] ?? '';
          // Store the last message in a list
          lastMessages.add(lastMessage);
          lastMessagesstatus.add(lastMessagests);
        });
      }
    }
  }

// Normalize phone number by removing country code and formatting consistently
  String normalizePhoneNumber(String number) {
    return number.replaceAll(RegExp(r'\s+|-|\(|\)|\+'), '');
  }

  @override
  void initState() {
    super.initState();
    // Fetch contacts and update online status when the app starts
    getContacts();
    getrecentchats();
    updateactivity();

    // Add this observer to listen for lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // If the app goes to the background or is closed, set user status to offline
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      setUserOffline();
    }

    // If the app comes to the foreground, set user status to online
    if (state == AppLifecycleState.resumed) {
      updateactivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhatsAppColors.darkGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: WhatsAppColors.darkGreen,
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {},
                child:
                    const Icon(Icons.camera_alt_outlined, color: Colors.white),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: const Icon(CupertinoIcons.ellipsis_vertical,
                    color: Colors.white),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
        title: Text(
          'Connect',
          style: GoogleFonts.actor(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: contactname.length > 1 && contactnumber.length > 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllContacts(
                        contactname: contactname, contactnumber: contactnumber),
                  ),
                );
              },
              backgroundColor: WhatsAppColors.primaryGreen,
              child: const Icon(Icons.add_comment, color: Colors.black),
            )
          : Container(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Search bar
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Center(
                      child: Text(
                        'Ask AI or Search',
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Directly wrap ListView.builder instead of using Expanded
              OtherUserUIDS.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: OtherUserUIDS.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChattingPage(
                                        UserID: OtherUserUIDS[index],
                                        Name: '+91 ${ContactName[index]}',
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '+91 ${ContactName[index]}',
                                            style: GoogleFonts.poppins(
                                                color: CupertinoColors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          if (lastMessages.isNotEmpty)
                                            Row(
                                              children: [
                                                Icon(
                                                  lastMessagesstatus[index] ==
                                                          'sent'
                                                      ? Icons.check
                                                      : lastMessagesstatus[
                                                                  index] ==
                                                              'delivered'
                                                          ? CupertinoIcons
                                                              .checkmark_alt_circle_fill
                                                          : CupertinoIcons
                                                              .clock,
                                                  color: CupertinoColors.white,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  lastMessages[index],
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Display the last message under the user's name
                            ],
                          ),
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
