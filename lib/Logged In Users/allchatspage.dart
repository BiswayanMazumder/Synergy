import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pingstar/AI%20Chat%20Page/AIChat.dart';
import 'package:pingstar/Accounts/accounts_details.dart';
import 'package:pingstar/Chat%20Page/UserChats.dart';
import 'package:pingstar/Contact%20Page/AllContacts.dart';
import 'package:pingstar/Utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../Status Pages/upload_status.dart';

class AllChats extends StatefulWidget {
  const AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();

  List<String> contactname = [];
  List<String> contactnumber = [];
  List<String> ContactNumber = [];
  List<String> ContactName = [];
  List<String> OtherUserUIDS = [];
  List<String> lastMessages = [];
  List<String> lastMessagestype = [];
  List<String> lastMessagesstatus = [];

  String usercontactnumber = '';
  String mobileNumber = '';
  String _searchQuery = '';
  String ImageUrl = '';
  bool longpressed = false;
  File? _image;

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
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> updateactivity() async {
    try {
      await getcontactnumber();
      await _firestore
          .collection('User Details(User ID Basis)')
          .doc(_auth.currentUser!.uid)
          .update({'User Online': true});
      await _firestore
          .collection('User Details(Contact Number Basis)')
          .doc(usercontactnumber)
          .update({'User Online': true});
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> setUserOffline() async {
    try {
      await getcontactnumber();
      await _firestore
          .collection('User Details(User ID Basis)')
          .doc(_auth.currentUser!.uid)
          .update({'User Online': false});
      await _firestore
          .collection('User Details(Contact Number Basis)')
          .doc(usercontactnumber)
          .update({'User Online': false});
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  void _listenToStatus() {
    _firestore
        .collection('Users Status')
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .listen((docsnap) {
      if (docsnap.exists) {
        setState(() {
          ImageUrl = docsnap.data()?['Image URL'];
        });
      }
    });
  }

  Future<void> getContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        List<Contact> contacts =
        await FlutterContacts.getContacts(withProperties: true);

        List<String> names = [];
        List<String> numbers = [];

        for (var contact in contacts) {
          String name = contact.displayName ?? 'Unnamed Contact';
          String phoneNumber = contact.phones.isNotEmpty
              ? contact.phones.first.number ?? 'No phone number'
              : 'No phone number';

          names.add(name);
          numbers.add(normalizePhoneNumber(phoneNumber));
        }

        setState(() {
          contactname = names;
          contactnumber = numbers;
        });
      }
    } catch (e) {
      if (kDebugMode) print('Failed to fetch contacts: $e');
    }
  }

  Future<void> getrecentchats() async {
    await getContacts();
    final docsnap = await _firestore
        .collection('Recent Chats')
        .doc(_auth.currentUser!.uid)
        .get();

    if (docsnap.exists) {
      final data = docsnap.data() as Map<String, dynamic>;
      OtherUserUIDS = List<String>.from(data['Other User UID'] ?? []);
    }

    for (int i = 0; i < OtherUserUIDS.length; i++) {
      final UserSnap = await _firestore
          .collection('User Details(User ID Basis)')
          .doc(OtherUserUIDS[i])
          .get();
      if (UserSnap.exists) {
        setState(() {
          mobileNumber = UserSnap.data()?['Mobile Number'] ?? '';
        });
      }
    }

    ContactNumber.add(mobileNumber);
    for (int i = 0; i < ContactNumber.length; i++) {
      if (contactnumber.contains(mobileNumber)) {
        int index = contactnumber.indexOf(mobileNumber);
        ContactName.add(contactname[index]);
      } else {
        ContactName.add(mobileNumber);
      }

      final lastMessageSnap = await _firestore
          .collection('chats')
          .where('senderID', isEqualTo: _auth.currentUser!.uid)
          .where('receiverID', isEqualTo: OtherUserUIDS[i])
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (lastMessageSnap.docs.isNotEmpty) {
        setState(() {
          lastMessages.add(lastMessageSnap.docs.first['message'] ?? '');
          lastMessagestype.add(lastMessageSnap.docs.first['messageType'] ?? '');
          lastMessagesstatus.add(lastMessageSnap.docs.first['status'] ?? '');
        });
      }
    }
  }

  String normalizePhoneNumber(String number) {
    String normalized = number.replaceAll(RegExp(r'\s+|-|\(|\)|\+'), '');
    if (normalized.startsWith('91') && normalized.length > 10) {
      normalized = normalized.substring(2);
    }
    return normalized;
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<int> _getFilteredIndexes() {
    if (_searchQuery.isEmpty) {
      return List<int>.generate(OtherUserUIDS.length, (index) => index);
    }
    return List<int>.generate(OtherUserUIDS.length, (index) => index)
        .where((index) =>
    ContactName[index].toLowerCase().contains(_searchQuery) ||
        ContactNumber[index].contains(_searchQuery))
        .toList();
  }

  Stream<QuerySnapshot> _messageStream(String otherUserID) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('senderID', isEqualTo: _auth.currentUser!.uid)
        .where('receiverID', isEqualTo: otherUserID)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StatusUploading(
                  image: _image, otherUID: _auth.currentUser!.uid)));
    }
  }

  @override
  void initState() {
    super.initState();
    _listenToStatus();
    _searchController.addListener(_onSearchChanged);
    getContacts();
    getrecentchats();
    updateactivity();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      setUserOffline();
    }
    if (state == AppLifecycleState.resumed) {
      updateactivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredIndexes = _getFilteredIndexes();

    return Scaffold(
      backgroundColor: WhatsAppColors.darkGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: WhatsAppColors.darkGreen,
        actions: [
          longpressed
              ? Row(
            children: [
              InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String selectedUID = prefs.getString('Selected_UID')!;
                  OtherUserUIDS.remove(selectedUID);
                  setState(() {
                    longpressed = false;
                  });
                },
                child: const Icon(
                    CupertinoIcons.delete, color: CupertinoColors.white),
              ),
              const SizedBox(width: 20),
            ],
          )
              : Row(
            children: [
              InkWell(
                onTap: () {
                  if (ImageUrl == '') {
                    _pickImage();
                  }
                },
                child:
                const Icon(Icons.camera_alt_outlined, color: Colors.white),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Accounts_Page()));
                },
                child: const Icon(CupertinoIcons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
        title: longpressed
            ? InkWell(
          onTap: () {
            setState(() {
              longpressed = false;
            });
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        )
            : Text(
          'Connect',
          style: GoogleFonts.actor(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: contactname.isNotEmpty && contactnumber.isNotEmpty
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
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
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
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: 'Search by name or number',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredIndexes.length,
                    itemBuilder: (context, index) {
                      final int actualIndex = filteredIndexes[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onLongPress: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString('Selected_UID', OtherUserUIDS[index]);
                            setState(() {
                              longpressed = true;
                            });
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChattingPage(
                                  UserID: OtherUserUIDS[actualIndex],
                                  Name: ContactName[actualIndex],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: longpressed ? Colors.green.shade900 : Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                                      ),
                                      longpressed
                                          ? const Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: Colors.green,
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.black,
                                            size: 10,
                                          ),
                                        ),
                                      )
                                          : Container()
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ContactName[actualIndex],
                                        style: GoogleFonts.poppins(
                                          color: CupertinoColors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.check,
                                            color: CupertinoColors.white,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            lastMessages[actualIndex],
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
