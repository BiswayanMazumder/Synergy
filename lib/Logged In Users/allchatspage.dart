import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pingstar/Contact%20Page/AllContacts.dart';
import 'package:pingstar/Utils/colors.dart';
class AllChats extends StatefulWidget {
  const AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  bool inallchatpage=true;
  List<Contact> _contacts=[];
  List<String> contactname = [];  // List to store contact names
  List<String> contactnumber = [];  // List to store contact numbers

  Future<void> getcontacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      try {
        // Fetch the contacts
        List<Contact> contacts = await ContactsService.getContacts();

        // Loop through each contact and store the name and phone number separately
        for (var contact in contacts) {
          // Get the contact name
          String contactName = contact.displayName ?? 'Unnamed Contact';
          contactname.add(contactName);

          // Get the contact phone number, if available
          String contactPhoneNumber = (contact.phones != null && contact.phones!.isNotEmpty)
              ? contact.phones!.first.value ?? 'No phone number'
              : 'No phone number';
          contactnumber.add(contactPhoneNumber);
        }

        // Print the lists after the loop finishes
        if (kDebugMode) {
          print('Contact Names List:');
          print(contactname);

          print('Contact Numbers List:');
          print(contactnumber);
        }

      } catch (e) {
        if (kDebugMode) {
          print('Failed to load contacts: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('Contact permission denied');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcontacts();
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
                onTap: (){},
                child:const Icon(Icons.camera_alt_outlined,color: Colors.white,),
              ),
              const SizedBox(
                width: 10,
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
        title: Text('Connect',style: GoogleFonts.actor(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print('hii');
        Navigator.push(context, MaterialPageRoute(builder: (context) => AllContacts(contactname: contactname,contactnumber: contactnumber,),));
      },
      backgroundColor: WhatsAppColors.primaryGreen,
      child: const Icon(Icons.add_comment,color: Colors.black,),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                decoration:  BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: const BorderRadius.all(Radius.circular(50))
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Center(
                      child: Text('Ask AI or Search',style: GoogleFonts.poppins(
                        color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 15
                      ),),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
