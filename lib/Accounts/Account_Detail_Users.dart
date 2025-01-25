import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Audio%20And%20Video%20Call/VideoCall.dart';
import 'package:pingstar/Chat%20Page/UserChats.dart';
import 'package:pingstar/Utils/colors.dart';
class Chatter_Details extends StatefulWidget {
  final String UserID;
  final String Name;

  const Chatter_Details({super.key, required this.UserID, required this.Name});

  @override
  State<Chatter_Details> createState() => _Chatter_DetailsState();
}

class _Chatter_DetailsState extends State<Chatter_Details> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String contactnumber = '';
  String status = '';
  String profilepicture = '';
  String username = '';
  Future<void> getprofiledetails() async {
    final docsnap = await _firestore
        .collection('User Details(User ID Basis)')
        .doc(widget.UserID)
        .get();
    if (docsnap.exists) {
      setState(() {
        contactnumber = docsnap.data()?['Mobile Number'];
        status = docsnap.data()?['Status'];
        profilepicture = docsnap.data()?['Profile Picture'] ??
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
        username = docsnap.data()?['Username'];
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofiledetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhatsAppColors.darkGreen,
      appBar: AppBar(
        backgroundColor: WhatsAppColors.darkGreen,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilepicture),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text('+91 ${widget.Name}',style: GoogleFonts.poppins(
                color: Colors.white,fontSize: 20
              ),),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(username,style: GoogleFonts.poppins(
                  color: Colors.grey,fontSize: 15
              ),),
            ),
            const SizedBox(
              height: 40,
            ),
             Padding(
               padding: const EdgeInsets.only(left: 20,right: 20),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(status,style: GoogleFonts.poppins(
                             color: Colors.white,fontSize: 15
                         ),),

                     ],
                   )
                 ],
               ),
             ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: WhatsAppColors.darkGreen,
                    borderRadius:const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: WhatsAppColors.primaryGreen)
                  ),
                  child:const Icon(Icons.call,color: WhatsAppColors.primaryGreen,),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>VideoCallPage(name: widget.Name,
                        userId: widget.UserID,
                        isInitiator: true) ,));
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: WhatsAppColors.darkGreen,
                        borderRadius:const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: WhatsAppColors.primaryGreen)
                    ),
                    child:const Icon(Icons.video_call,color: WhatsAppColors.primaryGreen,),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChattingPage(UserID: widget.UserID,
                        Name: widget.Name),));
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: WhatsAppColors.darkGreen,
                        borderRadius:const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: WhatsAppColors.primaryGreen)
                    ),
                    child:const Icon(Icons.message,color: WhatsAppColors.primaryGreen,),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
