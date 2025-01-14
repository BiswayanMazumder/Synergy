import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Logged%20In%20Users/allchatspage.dart';
import 'package:pingstar/Utils/colors.dart';
class ChattingPage extends StatefulWidget {
  final String UserID;
  final String Name;
  const ChattingPage({super.key, required this.UserID,required this.Name});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
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
            const SizedBox(
              width: 20,
            ),
            Text(widget.Name,style: GoogleFonts.poppins(
              color: Colors.white,fontSize: 16
            ),),
          ],
        ),
        actions:const [
          Row(
            children: [
              Icon(Icons.call,color: Colors.white,),
               SizedBox(
                width: 30,
              ),
              Icon(Icons.video_call,color: Colors.white,),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
        leading: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllChats(),));
          },
          child: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        backgroundColor: const Color.fromRGBO(12, 22, 28, 1.0),
      ),
    );
  }
}
