import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Utils/colors.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WhatsAppColors.darkGreen,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: WhatsAppColors.darkGreen,
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text('Enter your phone number',style: GoogleFonts.poppins(
                  color: Colors.white,fontSize: 25
                ),),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Synergy will need to verify your phone number.Carrier charges may apply.',style: GoogleFonts.poppins(
                  color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w400
              ),
              textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // height: 50,
                    width: 60,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.green, // Set the bottom border color to green
                          width: 2,            // Set the width of the bottom border
                        ),
                      ),
                    ),
                    child:const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          '+',
                          style: TextStyle(
                            color: Colors.grey, // White color for the plus sign
                            fontSize: 18
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        SizedBox(width: 4), // A small space between the plus sign and the number
                        Text(
                          '91',
                          style: TextStyle(
                            color: Colors.white, // Grey color for the number
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 28,
                    width: MediaQuery.sizeOf(context).width/3,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.green, // Set the bottom border color to green
                          width: 2,            // Set the width of the bottom border
                        ),
                      ),
                    ),
                  child: TextField(
                    style: GoogleFonts.poppins(
                      color: Colors.white
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey
                      )
                    ),
                  ),
                  )
                ],
              )
            ],
          ),
      ),

    );
  }
}
