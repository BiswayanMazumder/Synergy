import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Utils/colors.dart';
class AllContacts extends StatefulWidget {
  final List contactname;
  final List contactnumber;
  const AllContacts({super.key,required this.contactname,required this.contactnumber});

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future<void> getAllContacts() async {
    // Fetch all documents from the Firestore collection
    final docsnap = await _firestore.collection('User Details(User ID Basis)').get();

    // Check if the snapshot is not empty
    if (docsnap.docs.isNotEmpty) {
      List<String> contactNumbers = [];

      // Iterate over each document
      for (var doc in docsnap.docs) {
        // Assuming the contact number is stored under the field name 'contactNumber'
        var contactNumber = '${doc['Country Code']}${doc['Mobile Number']}';

        if (contactNumber != null) {
          contactNumbers.add(contactNumber);
          if(doc['UID']==_auth.currentUser!.uid){
            contactNumbers.remove(contactNumber);
          }
        }
      }

      // Print or use the contactNumbers list
      // if (kDebugMode) {
      //   print(contactNumbers);
      // }
    } else {
      if (kDebugMode) {
        print("No contacts found.");
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContacts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhatsAppColors.darkGreen,
      appBar: AppBar(
        actions: [
          Row(
            children: [
              InkWell(
                onTap: (){},
                child:const Icon(Icons.search,color: Colors.white,),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: (){},
                child:const Icon(CupertinoIcons.ellipsis_vertical,color: Colors.white,),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
        backgroundColor: WhatsAppColors.darkGreen,
        title: Text('Select Contacts',style: GoogleFonts.poppins(
          color: Colors.white
        ),),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child:const Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
    );
  }
}
