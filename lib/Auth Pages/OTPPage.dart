import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Utils/colors.dart';
class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WhatsAppColors.darkGreen,
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child:const Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      backgroundColor: WhatsAppColors.darkGreen,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Image(image: NetworkImage('https://cfyxewbfkabqzrtdyfxc.supabase.co/storage/v1/object/sign/Assets/otp-one-time-password-step-authentication-data-protection-'
                'internet-security-concept-otp-one-time-password-step-authentication-data-254434939-removebg-preview.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
                'eyJ1cmwiOiJBc3NldHMvb3RwLW9uZS10aW1lLXBhc3N3b3JkLXN0ZXAtYXV0aGVudGljYXRpb24tZGF0YS1wcm90ZWN0aW9uLWludGVybmV0LXNlY3VyaXR5LWNvbmNlcHQtb3RwLW9uZS10aW1lL'
                'XBhc3N3b3JkLXN0ZXAtYXV0aGVudGljYXRpb24tZGF0YS0yNTQ0MzQ5MzktcmVtb3ZlYmctcHJldmlldy5wbmciLCJpYXQiOjE3MzY3NDQxMDIsImV4cCI6MTc2ODI4MDEwMn0.eb0JVGRNasvKU_'
                'CwaK0yT7oUNacFuoL_02tBQLfe5C0&t=2025-01-13T04%3A55%3A03.816Z'),height: 200,width: 200,),
            const SizedBox(
              height: 20,
            ),
            Text('Please enter the valid 6-digit OTP recieved on your phone number.',style: GoogleFonts.poppins(
              color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18
            ),
            textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            OtpTextField(
              numberOfFields: 6,
              borderColor: WhatsAppColors.primaryGreen,
              keyboardType: TextInputType.number,
              styles: [
                TextStyle(
                  color: Colors.white
                ),
                TextStyle(
                    color: Colors.white
                ),
                TextStyle(
                    color: Colors.white
                ),
                TextStyle(
                    color: Colors.white
                ),
                TextStyle(
                    color: Colors.white
                ),TextStyle(
                    color: Colors.white
                ),

              ],
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
               // end onSubmit
            ),
          ],
        ),
      ),
    );
  }
}