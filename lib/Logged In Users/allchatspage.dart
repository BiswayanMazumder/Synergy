import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Utils/colors.dart';
class AllChats extends StatefulWidget {
  const AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  bool inallchatpage=true;
  bool inupdatepage=false;
  bool incallpage=false;
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
      floatingActionButton: FloatingActionButton(onPressed: (){},
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
              const SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Chats',style: GoogleFonts.poppins(
                      color:inallchatpage?Colors.green: Colors.white
                    ),),
                    Text('Updates',style: GoogleFonts.poppins(
                        color:inupdatepage?Colors.green: Colors.white
                    ),),
                    Text('Calls',style: GoogleFonts.poppins(
                        color:incallpage?Colors.green: Colors.white
                    ),),
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
