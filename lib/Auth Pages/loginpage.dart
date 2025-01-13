import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _PhoneNumberController = TextEditingController();
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WhatsAppColors.darkGreen,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: WhatsAppColors.darkGreen,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Enter your phone number',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Synergy will need to verify your phone number.Carrier charges may apply.',
              style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 28,
                  width: 60,
                  decoration:  BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:error==''? Colors
                            .green:Colors.red, // Set the bottom border color to green
                        width: 2, // Set the width of the bottom border
                      ),
                    ),
                  ),
                  child: TextField(
                    style: GoogleFonts.poppins(color: Colors.white),
                    keyboardType: TextInputType.number,
                    enabled: false,
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: '+91',
                        hintStyle: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Container(
                  height: 28,
                  width: MediaQuery.sizeOf(context).width / 3,
                  decoration:  BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:error==''? Colors
                            .green:Colors.red, // Set the bottom border color to green
                        width: 2, // Set the width of the bottom border
                      ),
                    ),
                  ),
                  child: TextField(
                    controller: _PhoneNumberController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey)),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                error,
                style: GoogleFonts.poppins(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                if (_PhoneNumberController.text.isEmpty) {
                  setState(() {
                    error = 'Please enter your number to continue';
                  });
                } else if (_PhoneNumberController.text.length < 10) {
                  setState(() {
                    error = 'Please enter a valid phone number';
                  });
                }
              },
              child: Container(
                width: 100,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: WhatsAppColors.primaryGreen,
                ),
                child: Center(
                  child: Text(
                    'NEXT',
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
