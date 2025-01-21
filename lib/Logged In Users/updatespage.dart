import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pingstar/Multimedia%20Viewing%20Pages/updateviewingpage.dart';
import 'package:pingstar/Status%20Pages/upload_status.dart';
import 'package:pingstar/Utils/colors.dart';
import 'dart:io';
class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key});

  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  bool statusseen = false;
  File? _image;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => StatusUploading(image: _image, otherUID:_auth.currentUser!.uid)));
    }
  }
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  String ImageUrl='';
  void _listenToStatus() {
    _firestore.collection('Users Status').doc(_auth.currentUser!.uid)
        .snapshots()
        .listen((docsnap) {
      if (docsnap.exists) {
        setState(() {
          ImageUrl = docsnap.data()?['Image URL'];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenToStatus();
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
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {},
                child: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
        title: Text(
          'Updates',
          style: GoogleFonts.actor(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Status',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                          if(ImageUrl==''){
                            _pickImage();
                          }
                          if(ImageUrl!=''){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateViewing(imageUrl: ImageUrl,Name: 'My Status'),));
                          }
                          },
                          child: Container(
                            height: 250,
                            width: 180,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade500.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: ImageUrl==''?Container():Container(
                              height: 250,
                              width: 180,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))
                              ),
                              child: Image(image: NetworkImage(ImageUrl),fit: BoxFit.fill,),
                            ),

                          ),
                        ),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration:  BoxDecoration(
                                color:statusseen?Colors.grey: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://g1uudlawy6t63z36.public.blob.vercel-storage.com/e64edd025438449584ac6c481eafa22d.png'),
                                  radius: 10,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            )
                        ),
                        const Positioned(
                            left: 40,
                            top: 40,
                            child: CircleAvatar(
                              backgroundColor: WhatsAppColors.primaryGreen,
                              radius: 10,
                              child: Icon(Icons.add,color: Colors.black,size:15,),
                            )),
                        Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              'My Status',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
